//
//  ShopViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 28/04/24.
//

import UIKit
import Combine

class ShopViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var cancellables = Set<AnyCancellable>()
    var activityIndicator: UIActivityIndicatorView?
    
    var pageViewController: UIPageViewController!
    var segmentControl: UISegmentedControl!
    var nigiriCountLabel: UILabel!
    
    lazy var pages: [UIViewController] = {
        let itemsVC = ItemsViewController()
        let purchasesVC = InAppPurchasesViewController()
        return [itemsVC, purchasesVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        
        setupPageViewController()
        setupSegmentControl()
        setupNigiriCountLabel()
        setupRestorePurchasesButton()
        IAPService.shared.fetchProducts()
        view.backgroundColor = .adButtonPurple.withAlphaComponent(0.75)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = false
        updateNigiriDisplay()
    }
    
    private func setupNigiriCountLabel() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        nigiriCountLabel = UILabel()
        nigiriCountLabel.font = UIFont(name: "Urbanist-Bold", size: 20)
        nigiriCountLabel.textColor = .white
        nigiriCountLabel.text = "\(GameManager.shared.nigiriBalance)"
        nigiriCountLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(nigiriCountLabel)

        let nigiriImage = UIImageView(image: UIImage(named: "nigiri_score"))
        nigiriImage.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(nigiriImage)

        NSLayoutConstraint.activate([
            nigiriCountLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            nigiriCountLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nigiriCountLabel.topAnchor.constraint(equalTo: container.topAnchor),
            nigiriCountLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            nigiriImage.heightAnchor.constraint(equalToConstant: 20),
            nigiriImage.widthAnchor.constraint(equalTo: nigiriImage.heightAnchor, multiplier: 1.53),
            nigiriImage.centerYAnchor.constraint(equalTo: nigiriCountLabel.centerYAnchor),
            nigiriImage.leadingAnchor.constraint(equalTo: nigiriCountLabel.trailingAnchor, constant: 4),
            nigiriImage.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        let nigiriBarItem = UIBarButtonItem(customView: container)
        navigationItem.rightBarButtonItem = nigiriBarItem
    }

    func updateNigiriDisplay() {
        nigiriCountLabel.text = "\(GameManager.shared.nigiriBalance)"
    }
    
    private func setupSegmentControl() {
        segmentControl = UISegmentedControl(
            items: [
                String(localized: "shop_page_items"),
                String(localized: "shop_page_nigiris")
            ]
        )
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentTintColor = .menuPurple.withAlphaComponent(0.5)
        segmentControl.backgroundColor = .menuPurple.withAlphaComponent(0.1)
        
        segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 22)!,
                NSAttributedString.Key.foregroundColor: UIColor.menuYellow
            ],
            for: .selected
        )
        
        segmentControl.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 16)!,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ],
            for: .normal
        )
        
        view.addSubview(segmentControl)

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let direction: UIPageViewController.NavigationDirection = sender.selectedSegmentIndex == 0 ? .reverse : .forward
        pageViewController.setViewControllers([pages[sender.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    private func setupRestorePurchasesButton() {
        let restoreButton = UIButton(type: .system)
        restoreButton.setTitle(String(localized: "restore_purchases"), for: .normal)
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        restoreButton.addTarget(self, action: #selector(restorePurchases), for: .touchUpInside)
        view.addSubview(restoreButton)

        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = self.view.center
        activityIndicator?.startAnimating()
        activityIndicator?.backgroundColor = .black.withAlphaComponent(0.5)
        self.view.addSubview(activityIndicator!)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator!.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hideActivityIndicator() {
        UIView.animate(withDuration: 0.3, animations: {
            self.activityIndicator?.alpha = 0
        }) { _ in
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    private func setupSubscriptions() {
        IAPService.shared.didRestorePurchases
            .receive(on: RunLoop.main)
            .sink { [weak self] didReceive in
                if didReceive {
                    self?.hideActivityIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func restorePurchases() {
        showActivityIndicator()
        IAPService.shared.restorePurchases()
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            segmentControl.selectedSegmentIndex = index
        }
    }
}

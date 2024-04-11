//
//  MenuViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit

class MenuViewController: UIViewController, UINavigationControllerDelegate {

    private var menuView = MenuView()
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        
        menuView.handlePlayTouch = didPressPlayButton
        menuView.handleRankingTouch = didPressRankingButton
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                return CustomNavigationAnimator()
            } else {
                return nil
            }
        }
    
    func didPressPlayButton() {
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    func didPressRankingButton() {
        let alertController = UIAlertController(title: "Hang tight!", message: "Rankings will be available soon!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

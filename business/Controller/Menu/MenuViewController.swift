//
//  MenuViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit
import GameKit
import GoogleMobileAds

class MenuViewController: UIViewController, UINavigationControllerDelegate, GKGameCenterControllerDelegate {

    private var menuView = MenuView()
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        
        menuView.handlePlayTouch = didPressPlayButton
        menuView.handleShopTouch = didPressShopButton
        menuView.handleRankingTouch = didPressRankingButton
        menuView.settingsView.handleJukeboxButtonTouch = didPressJukeboxButton
        
        navigationItem.title = "Menu"
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func appDidBecomeActive() {
        animateImageViewInfinitely(imageView: menuView.backgroundPaws)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        animateImageViewInfinitely(imageView: menuView.backgroundPaws)
        
        if menuView.settingsView.alpha == 1 {
            UIView.animate(
                withDuration: 1,
                delay: 1,
                options: [.repeat, .autoreverse, .allowUserInteraction]
            )
            {
                let alpha = self.menuView.settingsView.swipeLabel.alpha
                self.menuView.settingsView.swipeLabel.alpha = alpha == 1 ? 0 : 1
            }
        }
        
        if menuView.tutorialView.alpha == 1 {
            UIView.animate(
                withDuration: 1,
                delay: 1,
                options: [.repeat, .autoreverse, .allowUserInteraction]
            )
            {
                let alpha = self.menuView.tutorialView.swipeLabel.alpha
                self.menuView.tutorialView.swipeLabel.alpha = alpha == 1 ? 0 : 1
            }
        }
    }
    
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? 
    {
        if toVC.isKind(of: JukeboxViewController.self) 
            || fromVC.isKind(of: JukeboxViewController.self)
            || fromVC.isKind(of: ShopViewController.self)
        {
            return nil
        }
        
        if operation == .push || operation == .pop {
            return CustomNavigationAnimator()
        } else {
            return nil
        }
    }
    
    func didPressJukeboxButton() {
        navigationController?.pushViewController(JukeboxViewController(), animated: true)
    }
    
    func didPressPlayButton() {
        setupAudioForGame()
    
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    func didPressShopButton() {
        AnalyticsService.logEventShopButtonPressed()
        
        navigationController?.pushViewController(ShopViewController(), animated: true)
    }
    
    func didPressRankingButton() {
        AnalyticsService.logEventRankingButtonPressed()
        
        if GKLocalPlayer.local.isAuthenticated {
            GameCenterService.shared.presentGameCenter(from: self)
        }
        else {
            let alertController = UIAlertController(
                title: "Not connected!",
                message: "Connect to Game Center to view rankings!",
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    func animateImageViewInfinitely(imageView: UIImageView) {
        imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 20,
                       delay: 0,
                       options: [.curveLinear, .repeat, .transitionCrossDissolve],
                       animations: {
            imageView.transform = CGAffineTransform(
                translationX: -imageView.frame.size.width / 8,
                y: -imageView.frame.size.height / 12
            )
        })
    }
    
    func setupAudioForGame() {
        AudioManager.shared.loadSoundEffects(effects: [.wingFlap, .jump])
    }
}

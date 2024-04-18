//
//  MenuViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit
import GameKit

class MenuViewController: UIViewController, UINavigationControllerDelegate, GKGameCenterControllerDelegate {

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
    
    override func viewWillAppear(_ animated: Bool) {
        animateImageViewInfinitely(imageView: menuView.backgroundPaws)
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? 
    {
        if operation == .push || operation == .pop {
                return CustomNavigationAnimator()
            } else {
                return nil
            }
    }
    
    func didPressPlayButton() {
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    func didPressRankingButton() {
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

}

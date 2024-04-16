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
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
}

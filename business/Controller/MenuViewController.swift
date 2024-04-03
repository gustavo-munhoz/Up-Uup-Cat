//
//  MenuViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit

class MenuViewController: UIViewController {

    private var menuView = MenuView()
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.handlePlayTouch = didPressPlayButton
    }
    
    func didPressPlayButton() {
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
}

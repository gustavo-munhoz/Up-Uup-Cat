//
//  LaunchTransitionViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import UIKit

class LaunchTransitionViewController: UIViewController {
    
    private var launchTransitionView = LaunchTransitionView()
    
    override func loadView() {
        view = launchTransitionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundEffect.snore.play()
        
        launchTransitionView.startAnimation {
            BackgroundAudio.catNipDaze.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.pushViewController(MenuViewController(), animated: true)
            }
        }
    }
}

//
//  GameViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import UIKit
import SpriteKit
import GameplayKit
import Combine
import GoogleMobileAds

class GameViewController: AdViewController {
    private var cancellables = Set<AnyCancellable>()
    private var gameView = GameView()
    
    override func loadView() {
        view = gameView
        navigationItem.hidesBackButton = true
        
        handleReward = GameManager.shared.doubleNigiriCount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.shared.loadStats()
        
        setupSubscriptions()
        
        AdMobService.loadInterstitialAd(inAVC: self)
        AdMobService.loadRewardedAd(inAVC: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        gameView.setupSKScene()
    }
    
    func setupSubscriptions() {
        GameManager.shared.shouldReset.sink { shouldReset in
            if shouldReset {
                self.resetGameScene()
            }
        }
        .store(in: &cancellables)
        
        GameManager.shared.shouldShowRewardAd.sink { shouldShowRewardAd in
            if shouldShowRewardAd {
                AdMobService.showRewardedAd(atAVC: self)
            }
        }
        .store(in: &cancellables)
        
        GameManager.shared.shouldShowIntersticialAd.sink { shouldShowIntersticialAd in
            if shouldShowIntersticialAd {
                AdMobService.showInterstitialAd(atAVC: self)
            }
        }
        .store(in: &cancellables)
        
        GameManager.shared.shouldPopToMenuViewController.sink { shouldPopToMenu in
            if shouldPopToMenu {
                self.navigationController?.popViewController(animated: true)
            }
        }
        .store(in: &cancellables)
    }
}

extension GameViewController {
    @objc func resetGameScene() {
        let newGameScene = GameScene(size: gameView.skView.bounds.size)
        newGameScene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 0.4)
        gameView.skView.presentScene(newGameScene, transition: transition)
    }
}

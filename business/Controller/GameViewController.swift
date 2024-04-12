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

class GameViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var gameView = GameView()
    
    private var rewardedAd: GADRewardedAd?
    private var interstitialAd: GADInterstitialAd?
    
    override func loadView() {
        view = gameView
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.shared.loadStats()
        
        setupSubscriptions()
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
                self.loadRewardedAd() {
                    self.showRewardedAd()
                }
            }
        }
        .store(in: &cancellables)
        
        GameManager.shared.shouldShowIntersticialAd.sink { shouldShowIntersticialAd in
            if shouldShowIntersticialAd {
                self.loadInterstitialAd() {
                    self.showInterstitialAd()
                }
            }
        }
        .store(in: &cancellables)
    }
    
    @objc func resetGameScene() {
        let newGameScene = GameScene(size: gameView.skView.bounds.size)
        newGameScene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 0.4)
        gameView.skView.presentScene(newGameScene, transition: transition)
    }
}

// MARK: - AD RELATED METHODS
extension GameViewController: GADFullScreenContentDelegate {
    
    // MARK: - Rewarded
    func loadRewardedAd(_ completion: @escaping () -> Void = {}) {
        GADRewardedAd.load(withAdUnitID: Secrets.rewardAdId, request: GADRequest()) { [weak self] (ad, error) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            
            completion()
        }
    }
    
    func showRewardedAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                print("Reward given.")
            }
        } else {
            print("Ad was not ready.")
        }
    }
    
    // MARK: - Intersticial
    func loadInterstitialAd(_ completion: @escaping () -> Void = {}) {
        GADInterstitialAd.load(withAdUnitID: Secrets.interstitialAdId, request: GADRequest()) { [weak self] (ad, error) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            
            completion()
        }
    }
    
    func showInterstitialAd() {
        if let ad = interstitialAd {
            ad.present(fromRootViewController: self)
            
        } else {
            print("Ad was not ready.")
        }
    }
}

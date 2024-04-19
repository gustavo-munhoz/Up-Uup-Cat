//
//  GameManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/03/24.
//

import Combine
import Foundation
import FirebaseAnalytics
import GameKit

class GameManager {
    public static var shared = GameManager()
    
    private(set) var shouldReset = PassthroughSubject<Bool, Never>()
    
    private(set) var currentScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var personalBestScore: Int = 0
    
    private(set) var currentNigiriScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var nigiriBalance: Int = 0
    
    private(set) var shouldShowRewardAd = PassthroughSubject<Bool, Never>()
    private(set) var shouldShowIntersticialAd = PassthroughSubject<Bool, Never>()
    private(set) var shouldPopToMenuViewController = PassthroughSubject<Bool, Never>()
    private(set) var shouldAnimateDoubleNigiris = PassthroughSubject<[Int], Never>()
    
    private(set) var sessionGameCounts = 1 {
        didSet {
            if sessionGameCounts == 4 {
                shouldShowIntersticialAd.send(true)
                sessionGameCounts = 1
            }
        }
    }
    
    // MARK: - Ad Methods
    
    func requestDoubleNigiriAd() {
        shouldShowRewardAd.send(true)
    }
    
    func requestAnimateDoubleNigiriLabel() {
        shouldAnimateDoubleNigiris.send([currentNigiriScore.value, currentNigiriScore.value * 2])
    }
    
    func doubleNigiriCount() {
        requestAnimateDoubleNigiriLabel()
        
        currentNigiriScore.value *= 2
    }
    
    // MARK: - Game Methods
    
    func navigateBackToMenu() {
        shouldPopToMenuViewController.send(true)
    }
    
    func saveStats() {
        AnalyticsService.logEventPostScore(currentScore.value)
        AnalyticsService.logEventEarnVirtualCurrency(type: .nigiri, currentNigiriScore.value)
        
        if currentScore.value > personalBestScore {
            personalBestScore = currentScore.value
            saveHighScore(personalBestScore)
            
            if GKLocalPlayer.local.isAuthenticated {
                GameCenterService.shared.submitScore(
                    personalBestScore,
                    ids: [GC.GAME_CENTER.LEADERBOARDS.HIGHEST_HEIGHTS_ID])
                {
                    print("Score submitted to GameCenter: \(self.personalBestScore)")
                }
            }
        }
        
        saveNigiriBalance()
    }
    
    func resetGame() {
        sessionGameCounts += 1
        
        shouldReset.send(true)
        currentScore.value = 0
        currentNigiriScore.value = 0
    }
    
    func updateHighScore(_ newValue: Int) {
        self.currentScore.value = newValue
    }

    func increaseNigiriCount() {
        currentNigiriScore.value += 1
    }
    
    func loadStats() {
        personalBestScore = UserDefaults.standard.integer(forKey: "highScoreKey")
        nigiriBalance = UserDefaults.standard.integer(forKey: "nigirBalanceKey")
    }
    
    // MARK: - User Defaults Methods
    
    private func saveHighScore(_ highScore: Int) {
        UserDefaults.standard.set(highScore, forKey: "highScoreKey")
    }

    
    private func saveNigiriBalance() {
        nigiriBalance += currentNigiriScore.value
        
        UserDefaults.standard.set(nigiriBalance, forKey: "nigiriBalanceKey")
    }
}

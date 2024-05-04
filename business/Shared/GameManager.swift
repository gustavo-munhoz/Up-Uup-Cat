//
//  GameManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/03/24.
//

import Combine
import Foundation
import FirebaseAnalytics
import FirebaseFirestore
import GameKit

class GameManager {
    public static var shared = GameManager()
    
    private let db = Firestore.firestore()
    
    private(set) var shouldReset = PassthroughSubject<Bool, Never>()
    private(set) var shouldPause = PassthroughSubject<Bool, Never>()
    private(set) var shouldResume = PassthroughSubject<Bool, Never>()
    private(set) var shouldEnd = PassthroughSubject<Bool, Never>()
    private(set) var shouldPopToMenuViewController = PassthroughSubject<Bool, Never>()
    
    private(set) var currentScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var personalBestScore: Int = 0
    
    private(set) var currentNigiriScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var nigiriBalance: Int = 0
    
    
    private(set) var shouldShowRewardAd = PassthroughSubject<Bool, Never>()
    private(set) var shouldShowIntersticialAd = PassthroughSubject<Bool, Never>()
    private(set) var shouldAnimateDoubleNigiris = PassthroughSubject<[Int], Never>()
    private(set) var didFinishShowingRewardedAd = PassthroughSubject<Bool, Never>()
    
    private(set) var sessionGameCounts = 1 {
        didSet {
            if sessionGameCounts == 3 {
                shouldShowIntersticialAd.send(true)
                sessionGameCounts = 1
            }
        }
    }
    
    private init() {}
    
    // MARK: - Ad Methods
    
    func requestDoubleNigiriAd() {
        shouldShowRewardAd.send(true)
    }
    
    func didDismissRewardedAd() {
        didFinishShowingRewardedAd.send(true)
    }
    
    // MARK: - Game Methods
    
    func pauseGame() {
        shouldPause.send(true)
    }
    
    func resumeGame() {
        shouldResume.send(true)
    }
    
    func endGame() {
        shouldEnd.send(true)
    }
    
    func resetGame() {
        sessionGameCounts += 1
        
        shouldReset.send(true)
        currentScore.value = 0
        currentNigiriScore.value = 0
    }
    
    func navigateBackToMenu() {
        shouldPopToMenuViewController.send(true)
    }
    
    func saveStats() {
        AnalyticsService.logEventPostScore(currentScore.value)
        AnalyticsService.logEventEarnVirtualCurrency(type: .nigiri, currentNigiriScore.value)
        
        if currentScore.value > personalBestScore {
            personalBestScore = currentScore.value
            saveHighScore(personalBestScore)
        }
        
        if GKLocalPlayer.local.isAuthenticated {
            GameCenterService.shared.submitScore(
                currentScore.value,
                ids: [GC.GAME_CENTER.LEADERBOARDS.HIGHEST_HEIGHTS_ID])
            {
                print("Score submitted to GameCenter: \(self.currentScore.value)")
            }
        }
        
        saveNigiriBalance()
    }
    
    func updateHighScore(_ newValue: Int) {
        self.currentScore.value = newValue
    }

    func increaseNigiriCount() {
        currentNigiriScore.value += 1
    }
    
    func loadStats() {
        personalBestScore = UserDefaults.standard.integer(forKey: UserDefaultsKeys.highScore)
        nigiriBalance = UserDefaults.standard.integer(forKey: UserDefaultsKeys.nigiriBalance)
        
        print("\nData retrieved from UserDefaults:\nBest Score: \(personalBestScore)\nNigiri Balance: \(nigiriBalance)\n")
        
        GameCenterService.shared.submitScore(
            personalBestScore,
            ids: [GC.GAME_CENTER.LEADERBOARDS.HIGHEST_HEIGHTS_ID]) {}
    }
    
    func setPersonalBest(_ value: Int) {
        personalBestScore = value
        UserDefaults.standard.set(value, forKey: UserDefaultsKeys.highScore)
    }
    
    func setNigiriBalance(_ value: Int) {
        nigiriBalance = value
        UserDefaults.standard.set(value, forKey: UserDefaultsKeys.nigiriBalance)
    }
    
    // MARK: - User Defaults Methods
    
    private func saveHighScore(_ highScore: Int) {
        UserPreferences.shared.setLocalHighscore(highScore)
        
        UserDefaults.standard.set(highScore, forKey: UserDefaultsKeys.highScore)
    }

    
    private func saveNigiriBalance() {
        nigiriBalance += currentNigiriScore.value
        
        UserPreferences.shared.setLocalNigiriBalance(nigiriBalance)
        UserDefaults.standard.set(nigiriBalance, forKey: UserDefaultsKeys.nigiriBalance)
    }
}

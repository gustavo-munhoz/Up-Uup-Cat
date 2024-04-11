//
//  GameManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/03/24.
//

import Combine
import Foundation
import FirebaseAnalytics

class GameManager {
    public static var shared = GameManager()
    
    private(set) var shouldReset = PassthroughSubject<Bool, Never>()
    
    private(set) var currentScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var personalBestScore: Int = 0
    
    private(set) var currentNigiriScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private(set) var nigiriBalance: Int = 0
    
    
    // MARK: - Public methods
    
    func saveStats() {
        AnalyticsService.logEventPostScore(currentScore.value)
        AnalyticsService.logEventEarnVirtualCurrency(type: .nigiri, currentNigiriScore.value)
        
        if currentScore.value > personalBestScore {
            personalBestScore = currentScore.value
            saveHighScore(personalBestScore)
        }
        
        saveNigiriBalance()
    }
    
    func resetGame() {
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
    
    // MARK: - Private methods
    
    private func saveHighScore(_ highScore: Int) {
        UserDefaults.standard.set(highScore, forKey: "highScoreKey")
    }

    
    private func saveNigiriBalance() {
        nigiriBalance += currentNigiriScore.value
        
        UserDefaults.standard.set(nigiriBalance, forKey: "nigiriBalanceKey")
    }
}

//
//  GameManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/03/24.
//

import Combine
import Foundation

class GameManager {
    public static var shared = GameManager()
    
    private(set) var shouldReset = PassthroughSubject<Bool, Never>()
    
    private(set) var currentScore: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    
    private(set) var personalBestScore: Int = 0
    
    func resetGame() {
        if currentScore.value > personalBestScore {
            personalBestScore = currentScore.value
            saveHighScore(personalBestScore)
        }
        
        shouldReset.send(true)
        currentScore.value = 0
    }
    
    func updateHighScore(_ newValue: Int) {
        self.currentScore.value = newValue
    }
    
    func saveHighScore(_ highScore: Int) {
        UserDefaults.standard.set(highScore, forKey: "highScoreKey")
    }

    func loadHighScore() {
        personalBestScore = UserDefaults.standard.integer(forKey: "highScoreKey")
    }
}

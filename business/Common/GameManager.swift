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
    
    private(set) var score: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    
    private(set) var currentHighScore: Int = 0
    
    func resetGame() {
        if score.value > currentHighScore {
            currentHighScore = score.value
            saveHighScore(currentHighScore)
        }
        
        shouldReset.send(true)
        score.value = 0
    }
    
    func updateHighScore(_ newValue: Int) {
        self.score.value = newValue
    }
    
    func saveHighScore(_ highScore: Int) {
        UserDefaults.standard.set(highScore, forKey: "highScoreKey")
    }

    func loadHighScore() {
        currentHighScore = UserDefaults.standard.integer(forKey: "highScoreKey")
    }
}

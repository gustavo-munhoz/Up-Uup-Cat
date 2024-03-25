//
//  GameManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/03/24.
//

import Combine

class GameManager {
    public static var shared = GameManager()
    
    private(set) var shouldReset = PassthroughSubject<Bool, Never>()
    
    func resetGame() {
        shouldReset.send(true)
    }
}

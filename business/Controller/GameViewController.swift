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

class GameViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var gameView = GameView()
    
    override func loadView() {
        view = gameView
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.shared.loadHighScore()
        
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
    }
    
    @objc func resetGameScene() {
        let newGameScene = GameScene(size: gameView.skView.bounds.size)
        newGameScene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 0.4)
        gameView.skView.presentScene(newGameScene, transition: transition)
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom, .top]
    }
}


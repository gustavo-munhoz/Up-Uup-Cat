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
    
    private var sceneNode: GameScene? {
        if let scene = GKScene(fileNamed: "GameScene") {
            return scene.rootNode as? GameScene
        }
        
        return nil
    }
    
    private lazy var maxHeightLabel: UILabel = {
        let maxHeightLabel = UILabel()
        maxHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        maxHeightLabel.textColor = .white
        
        return maxHeightLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let skView = self.view as? SKView else {
            print("Could not cast the view to SKView.")
            return
        }
        
        if let sceneNode = sceneNode {
            sceneNode.scaleMode = .aspectFill
            
            skView.presentScene(sceneNode)
            skView.ignoresSiblingOrder = true
            
            GameManager.shared.loadHighScore()
        }
        
        setupSubscriptions()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        true
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
        if let view = self.view as! SKView? {
            if let scene = GKScene(fileNamed: "GameScene") {
                if let sceneNode = scene.rootNode as! GameScene? {
                    sceneNode.scaleMode = .aspectFill
                    
                    let transition = SKTransition.fade(withDuration: 0.4)
                    
                    view.presentScene(sceneNode, transition: transition)
                }
            }
            
            view.ignoresSiblingOrder = true
        }
    }
}


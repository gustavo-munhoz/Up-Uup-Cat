//
//  ContactManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 17/04/24.
//

import SpriteKit

class SceneContactManager {
    weak var scene: GameScene?
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func handleContact(_ contact: SKPhysicsContact) {
        guard let scene = scene else { return }
        
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        let bodies = [bodyA, bodyB]
        
        let cat = bodies.first { $0.categoryBitMask == PhysicsCategory.player }
        let cucumber = bodies.first { $0.categoryBitMask == PhysicsCategory.enemy }
        let collectibleNode = bodies.first { $0.categoryBitMask == PhysicsCategory.collectible }
        
        guard let _ = cat else { return }
        
        if let _ = cucumber {
            scene.cucumberEntity.isJumpingAtPlayer = false
            
            scene.handleCatDeath()
            
            return
        }
        
        if let collectibleNode = collectibleNode?.node as? CollectibleNode, !scene.isGameOver, !scene.isPaused {
            scene.catEntity.collectItem(c: collectibleNode.type) {
                switch collectibleNode.type {
                    case .nigiri:
                        scene.hud.updateNigiriScore(GameManager.shared.currentNigiriScore.value)
                        
                    case .catnip:
                        scene.cameraManager.zoomOutByCatnip()
                        scene.hud.handleCatnipPickup()
                }
                collectibleNode.removeFromParent()
            }
            return
        }
    }
}

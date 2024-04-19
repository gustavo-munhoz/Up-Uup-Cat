//
//  SceneUpdateManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 17/04/24.
//

import SpriteKit

class SceneUpdateManager {
    weak var scene: GameScene?
    
    init(scene: GameScene? = nil) {
        self.scene = scene
    }
    
    func handleUpdate(currentTime: TimeInterval) {
        guard let scene = scene else { return }
        
        if scene.canStart && !scene.isGameOver  {
            scene.cameraManager.updateCameraPosition(catEntity: scene.catEntity)   
        }
        
        if scene.lastUpdateTime == 0 { scene.lastUpdateTime = currentTime }
        
        if scene.zoomOutTimer == nil && scene.hasStarted {
            scene.cameraManager.resetZoom()
        }
        
        if scene.hasStarted { scene.handleCucumberMovement(currentTime: currentTime) }
        else if !scene.hasGeneratedFirstWalls {
            for _ in 0..<30 { scene.handleWallGeneration() }
            
            scene.hasGeneratedFirstWalls = true
        }
        
        guard scene.catEntity.spriteComponent.node.physicsBody?.velocity != .zero else { return }

        scene.handleCatMovement()
        
        if scene.isGrabbingGlass {
            scene.catEntity.spriteComponent.node.physicsBody?.applyForce(GC.GLASS_FORCE)
        }
        
        scene.handleWallGeneration()
        
        if let arrow = scene.arrowNode {
            let newPosition = CGPoint(
                x: scene.catEntity.spriteComponent.node.position.x,
                y: scene.catEntity.spriteComponent.node.position.y + scene.catEntity.spriteComponent.node.frame.height/2
            )
            arrow.updateBasePosition(to: newPosition)
        }
    }
}

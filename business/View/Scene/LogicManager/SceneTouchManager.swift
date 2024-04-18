//
//  TouchManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 17/04/24.
//

import SpriteKit

class SceneTouchManager {
    weak var scene: GameScene?
    var touchStart: CGPoint?
    var isTouchingButton = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let scene = scene else { return }
        let location = touch.location(in: scene.cameraManager.cameraNode)
        touchStart = location
        
        guard let touchStart = touchStart else { return }
        
        if scene.hud.pauseButton.contains(touchStart) && !scene.isGameOver {
            handleButtonTouch(scene.hud.pauseButton)
        }
        
        else if scene.pauseScreen.continueButton.contains(touchStart) && !scene.isGameOver {
            handleButtonTouch(scene.pauseScreen.continueButton)
        }
        
        else if scene.pauseScreen.homeButton.contains(touchStart) && !scene.isGameOver {
            handleButtonTouch(scene.pauseScreen.homeButton)
        }
        
        else if scene.gameOverScreen.watchAdButton.contains(touchStart) && scene.isGameOver {
            handleButtonTouch(scene.gameOverScreen.watchAdButton)
        }
        
        else if scene.gameOverScreen.restartButton.contains(touchStart) && scene.isGameOver {
            handleButtonTouch(scene.gameOverScreen.restartButton)
        }
        
        else if scene.gameOverScreen.homeButton.contains(touchStart) && scene.isGameOver {
            handleButtonTouch(scene.gameOverScreen.homeButton)
        }
        
        else {
            prepareForJumpIfNeeded()
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene, !isTouchingButton, let touch = touches.first, let start = touchStart else { return }
        let touchLocation = touch.location(in: scene.cameraManager.cameraNode)
        
        scene.arrowNode?.update(start: start, end: touchLocation)
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene, let touch = touches.first, let start = touchStart else { return }
        
        let location = touch.location(in: scene.cameraManager.cameraNode)
        
        if isTouchingButton {
            if scene.hud.pauseButton.contains(location) && !scene.isPaused && !scene.isGameOver {
                scene.hud.pauseButton.alpha = 1
                scene.togglePause()
            }
            
            else if scene.pauseScreen.continueButton.contains(location) && scene.isPaused && !scene.isGameOver {
                scene.pauseScreen.continueButton.alpha = 1
                scene.togglePause()
            }
            
            else if scene.pauseScreen.homeButton.contains(location) && scene.isPaused && !scene.isGameOver {
                scene.pauseScreen.homeButton.alpha = 1
                GameManager.shared.navigateBackToMenu()
            }
            
            else if scene.gameOverScreen.watchAdButton.contains(location) && scene.isGameOver {
                GameManager.shared.requestDoubleNigiriAd()
            }
            
            else if scene.gameOverScreen.restartButton.contains(location) && scene.isGameOver {
                AnalyticsService.logEventPressedRestart()
                GameManager.shared.resetGame()
            }
            
            else if scene.gameOverScreen.homeButton.contains(location) && scene.isGameOver {
                GameManager.shared.navigateBackToMenu()
            }

            isTouchingButton = false
            return
        }
        
        if !scene.hasStarted {
            if scene.canStart { scene.hasStarted = true }
            else { return }
        }
        
        if scene.zoomOutTimer != nil {
            scene.zoomOutTimer?.invalidate()
            scene.zoomOutTimer = nil
        }
        
        scene.catEntity.handleJump(from: start, to: location)
        
        scene.isGrabbingGlass = false
        deleteArrowNodeFromScene()
    }
    
    private func prepareForJumpIfNeeded() {
        guard let scene = scene, scene.catEntity.spriteComponent.currentWallMaterial != .none,
              !scene.isPaused, scene.canStart else { return }
        
        scene.zoomOutTimer?.invalidate()
        scene.zoomOutTimer = Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
            scene.cameraManager.zoomOut()
        }
        
        createArrowNodeInScene()
        scene.catEntity.prepareForJump(hasStarted: scene.hasStarted, isTouching: true)
        
        scene.isGrabbingGlass = scene.catEntity.spriteComponent.currentWallMaterial == .glass
    }
    
    func handleButtonTouch(_ button: SKNode) {
        button.alpha = 0.5
        isTouchingButton = true
    }
    
    func createArrowNodeInScene() {
        guard let scene = scene else { return }
        
        scene.arrowNode = ArrowNode(
            catPosition: CGPoint(
                x: scene.catEntity.spriteComponent.node.position.x,
                y: scene.catEntity.spriteComponent.node.position.y + scene.catEntity.spriteComponent.node.frame.height/2
            )
        )
        
        scene.addChild(scene.arrowNode!)
    }
    
    func deleteArrowNodeFromScene() {
        guard let scene = scene else { return }
        
        scene.arrowNode?.removeFromParent()
        scene.arrowNode = nil
    }
}

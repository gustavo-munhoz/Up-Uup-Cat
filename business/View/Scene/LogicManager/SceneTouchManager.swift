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
                GameManager.shared.pauseGame()
                SoundEffect.pop.playIfAllowed()
                scene.hud.pauseButton.alpha = 1
                scene.isPaused = true
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
            if !scene.catEntity.isPumpedUpByCatnip.value {
                scene.cameraManager.resetZoom()
            }
        }
        
        scene.catEntity.handleJump(from: start, to: location)
        
        scene.isGrabbingGlass = false
        deleteArrowNodeFromScene()
    }
    
    private func prepareForJumpIfNeeded() {
        guard let scene = scene, scene.catEntity.spriteComponent.currentWallMaterial != .none,
              !scene.isPaused, scene.canStart else { return }
        
        if scene.hasStarted {
            SoundEffect.claws2.playIfAllowed()
        }
        
        scene.zoomOutTimer?.invalidate()
        scene.zoomOutTimer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { _ in
            if !scene.catEntity.isPumpedUpByCatnip.value {
                scene.cameraManager.zoomOut()
            }
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

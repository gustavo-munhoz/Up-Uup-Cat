//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var hasStarted = false
    
    var cameraNode: SKCameraNode!
    var wallGenerateTrigger: Double!
    
    var touchStart: CGPoint?
    var zoomOutTimer: Timer?
    var lastUpdateTime: TimeInterval = 0
    
    var wallFactory: WallFactory!
    var existingWalls: [WallNode] = []
    
    var catEntity: CatEntity!
    var cucumberEntity: CucumberEntity!
    
    // MARK: - Scene setup
    override func didMove(to view: SKView) {
        wallGenerateTrigger = frame.height * 0.3
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        
        wallFactory = WallFactory(frame: frame, cameraPositionY: cameraNode.position.y)
        
        let initialWalls = wallFactory.createInitialWalls()
        
        catEntity = CatEntity(size: CGSize(width: 30, height: 70))
        
        if let catNode = catEntity.component(ofType: CatSpriteComponent.self)?.node {
            catNode.position = CGPoint(x: frame.midX - 50, y: -frame.height * 0.25)
            catNode.zPosition = 2
            addChild(catNode)
        }
        
        cucumberEntity = CucumberEntity(size: CGSize(width: 50, height: 80))
        if let cucumberNode = cucumberEntity.component(ofType: CucumberSpriteComponent.self)?.node {
            cucumberNode.position = CGPoint(x: frame.minX + 50, y: -frame.height * 0.5)
            cucumberNode.zPosition = 5
            addChild(cucumberNode)
        }
        
        addChild(cameraNode)
        
        for wall in initialWalls {
            existingWalls.append(wall)
            addChild(wall)
        }
        
        // Needed for cat standing still at startup
        catEntity.prepareForJump()
        
        catEntity.agentComponent.setPosition(catEntity.spriteComponent.node.position)
        cucumberEntity.agentComponent.setPosition(cucumberEntity.spriteComponent.node.position)
    }

    
    // MARK: - Default methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let camera = cameraNode else { return }
        touchStart = touch.location(in: camera)
        
        guard catEntity.spriteComponent.currentWallMaterial != .none else { return }
        
        catEntity.prepareForJump()
        
        zoomOutTimer = Timer.scheduledTimer(withTimeInterval: 5/6, repeats: false) { [weak self] _ in
            self?.zoomOutCamera()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart, let camera = cameraNode else { return }
        
        if !hasStarted { hasStarted = true }
        
        let location = touch.location(in: camera)
        
        catEntity.handleJump(from: start, to: location)
        
        zoomOutTimer?.invalidate()
        zoomOutTimer = nil

        resetCamera()
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        updateCameraPosition()
        
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        if hasStarted { handleCucumberMovement(currentTime: currentTime) }
        
        guard catEntity.spriteComponent.node.physicsBody?.velocity != .zero else { return }
        
        handleCatMovement()
        handleWallGeneration()
        wallFactory.cameraPositionY = cameraNode.position.y
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if bodyA.node?.name == "cat" && bodyB.node?.name == "enemyCucumber"
            || bodyA.node?.name == "enemyCucumber" && bodyB.node?.name == "cat"
        {
            cucumberEntity.isJumpingAtPlayer = false
            GameManager.shared.resetGame()
        }
    }
    
    // MARK: - Custom methods
    
    func updateCameraPosition() {
        let catPosition = catEntity.spriteComponent.node.position

        let lerpFactor: CGFloat = 0.2

        let smoothedPosition = CGPoint(
            x: cameraNode.position.x + (catPosition.x - cameraNode.position.x) * lerpFactor,
            y: cameraNode.position.y + ((catPosition.y + frame.height * 0.1) - cameraNode.position.y) * lerpFactor
        )
        
        cameraNode.position = smoothedPosition
    }
    
    func zoomOutCamera() {
        let zoomOutAction = SKAction.scale(to: 1.5, duration: 0.5)
        zoomOutAction.timingMode = .easeInEaseOut
        cameraNode?.run(zoomOutAction)
    }
    
    func resetCamera() {
        let resetZoomAction = SKAction.scale(to: 1.0, duration: 0.5)
        resetZoomAction.timingMode = .easeInEaseOut
        cameraNode?.run(resetZoomAction)
    }
    
    func handleWallGeneration() {
        if cameraNode.position.y > wallGenerateTrigger {
            let newWall = wallFactory.createWall()
            existingWalls.append(newWall)
            addChild(newWall)
            
            wallGenerateTrigger += frame.size.height * 0.4
        }
    }
    
    func handleCatMovement() {
        for wall in existingWalls {
            let contactAreaWidth = wall.frame.width - catEntity.spriteComponent.node.frame.width
            let contactAreaHeight = wall.frame.height - catEntity.spriteComponent.node.frame.height

            let contactAreaOriginX = wall.position.x - contactAreaWidth / 2
            let contactAreaOriginY = wall.position.y - wall.frame.height / 2

            let contactAreaFrameInScene = CGRect(
                x: contactAreaOriginX,
                y: contactAreaOriginY,
                width: contactAreaWidth,
                height: contactAreaHeight
            )

            if catEntity.spriteComponent.node.frame.intersects(contactAreaFrameInScene) {
                catEntity.spriteComponent.currentWallMaterial = wall.material
                return
            }
        }
        catEntity.spriteComponent.currentWallMaterial = .none
    }
    
    func handleCucumberMovement(currentTime: TimeInterval) {
        if let vy = catEntity.spriteComponent.node.physicsBody?.velocity.dy, vy < -2000 {
            cucumberEntity.jumpAtPlayer(player: catEntity)
            
        } else if !cucumberEntity.isJumpingAtPlayer {
            cucumberEntity.updateTarget(catEntity.agentComponent.agent)
            var deltaTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            
            if deltaTime > 0.02 {
                deltaTime = 0.02
            }
            
            cucumberEntity.agentComponent.agent.update(deltaTime: deltaTime)
            catEntity.agentComponent.agent.update(deltaTime: deltaTime)
        }
    }
}

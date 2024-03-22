//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cameraNode: SKCameraNode!
    var wallGenerateTrigger: Double!
    
    var touchStart: CGPoint?
    var zoomOutTimer: Timer?
    
    var wallFactory: WallFactory!
    var existingWalls: [WallNode] = []

    var catNode: CatNode!
    
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
        
        catNode = CatNode(size: CGSize(width: 30, height: 70))
        catNode.position = CGPoint(x: frame.midX - 50, y: -frame.height * 0.25)
        catNode.zPosition = 2
        catNode.prepareForJump()
        
        addChild(cameraNode)
        
        for wall in initialWalls {
            existingWalls.append(wall)
            addChild(wall)
        }
        
        addChild(catNode)
    }
    
    // MARK: - Default methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let camera = cameraNode else { return }
        touchStart = touch.location(in: camera)
        
        guard catNode.currentWallMaterial != .none else { return }
        
        catNode.prepareForJump()
        
        zoomOutTimer = Timer.scheduledTimer(withTimeInterval: 5/6, repeats: false) { [weak self] _ in
            self?.zoomOutCamera()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart, let camera = cameraNode else { return }
        
        let location = touch.location(in: camera)
        
        catNode.handleJump(from: start, to: location)
        
        zoomOutTimer?.invalidate()
        zoomOutTimer = nil

        resetCamera()
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        updateCameraPosition()
        
        // Is already holding a wall, check is useless
        guard catNode.physicsBody?.velocity != .zero else { return }
        
        handleCatMovement()
        handleWallGeneration()
        wallFactory.cameraPositionY = cameraNode.position.y
    }
    
    // MARK: - Custom methods
    
    func updateCameraPosition() {
        if let catNode = self.childNode(withName: "cat") as? CatNode {
            let catPosition = catNode.position

            let lerpFactor: CGFloat = 0.2

            let smoothedPosition = CGPoint(
                x: cameraNode.position.x + (catPosition.x - cameraNode.position.x) * lerpFactor,
                y: cameraNode.position.y + ((catPosition.y + frame.height * 0.1) - cameraNode.position.y) * lerpFactor
            )
            
            cameraNode.position = smoothedPosition
        }
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
            let contactAreaWidth = wall.frame.width - catNode.frame.width
            let contactAreaHeight = wall.frame.height - catNode.frame.height

            let contactAreaOriginX = wall.position.x - contactAreaWidth / 2
            let contactAreaOriginY = wall.position.y - wall.frame.height / 2

            let contactAreaFrameInScene = CGRect(
                x: contactAreaOriginX,
                y: contactAreaOriginY,
                width: contactAreaWidth,
                height: contactAreaHeight
            )

            if catNode.frame.intersects(contactAreaFrameInScene) {
                catNode.currentWallMaterial = wall.material
                return
            }
        }
        catNode.currentWallMaterial = .none
    }

}

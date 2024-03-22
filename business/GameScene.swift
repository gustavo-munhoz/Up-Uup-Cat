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

    
    // MARK: - Scene setup
    
    override func didMove(to view: SKView) {
        wallGenerateTrigger = frame.height * 0.05
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        
        wallFactory = WallFactory(frame: frame, cameraPositionY: cameraNode.position.y)
        
        let floorSize = CGSize(width: frame.width * 2, height: 125)
        let floorNode = FloorNode(size: floorSize)
        floorNode.position = CGPoint(x: frame.midX, y: frame.minY + floorSize.height / 2)

        let normalWall1 = WallNode(size: CGSize(width: 350, height: 700), material: .normal)
        normalWall1.position = CGPoint(x: frame.midX + 200, y: -frame.height * 0.4)
        
        let normalWall2 = WallNode(size: CGSize(width: 200, height: 1000), material: .normal)
        normalWall2.position = CGPoint(x: frame.midX - 200, y: frame.height * 0.4)
        
        let normalWall3 = WallNode(size: CGSize(width: 200, height: 500), material: .glass)
        normalWall3.position = CGPoint(x: frame.midX + 200, y: frame.height * 0.2)
        
        let catNode = CatNode(size: CGSize(width: 50, height: 50))
        catNode.position = CGPoint(x: frame.midX - 50, y: -frame.height * 0.25)
        catNode.zPosition = 2
        
        addChild(cameraNode)
        addChild(normalWall1)
        addChild(normalWall2)
        addChild(normalWall3)
        addChild(floorNode)
        addChild(catNode)
    }
    
    // MARK: - Default methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let camera = cameraNode else { return }
        touchStart = touch.location(in: camera)
        
        guard let catNode = childNode(withName: "cat") as? CatNode, catNode.currentWallMaterial != .none else { return }
        
        catNode.prepareForJump()
        
        zoomOutTimer = Timer.scheduledTimer(withTimeInterval: 5/6, repeats: false) { [weak self] _ in
            self?.zoomOutCamera()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart, let camera = cameraNode,
              let catNode = childNode(withName: "cat") as? CatNode else { return }
        
        let location = touch.location(in: camera)
        
        catNode.handleJump(from: start, to: location)
        
        zoomOutTimer?.invalidate()
        zoomOutTimer = nil

        resetCamera()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.wall) ||
               (bodyA.categoryBitMask == PhysicsCategory.wall && bodyB.categoryBitMask == PhysicsCategory.player)
            {
                let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode
                let wallNode = (bodyA.categoryBitMask == PhysicsCategory.wall ? bodyA.node : bodyB.node) as? WallNode

                if let catNode = catNode, let wallNode = wallNode {
                    catNode.wallContacts.insert(wallNode.id)
                    catNode.currentWallMaterial = wallNode.material
                    
                }
            }
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.floor) ||
           (bodyA.categoryBitMask == PhysicsCategory.floor && bodyB.categoryBitMask == PhysicsCategory.player) {

            let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode

            if let catNode = catNode {
                catNode.canJump = true
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.wall) ||
           (bodyA.categoryBitMask == PhysicsCategory.wall && bodyB.categoryBitMask == PhysicsCategory.player)
        {
            let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode
            let wallNode = (bodyA.categoryBitMask == PhysicsCategory.wall ? bodyA.node : bodyB.node) as? WallNode
            
            if let catNode = catNode {
                if let wallNode = wallNode {
                    catNode.wallContacts.remove(wallNode.id)
                    if catNode.wallContacts.isEmpty {
                        catNode.currentWallMaterial = .none
                    }
                }
            }
        }
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.floor) ||
           (bodyA.categoryBitMask == PhysicsCategory.floor && bodyB.categoryBitMask == PhysicsCategory.player) {

            let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode

            if let catNode = catNode {
                catNode.canJump = false
            }
        }
    }


    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        updateCameraPosition()
        handleWallGeneration()
        wallFactory.cameraPositionY = cameraNode.position.y
    }
    
    // MARK: - Custom methods
    
    func updateCameraPosition() {
        if let catNode = self.childNode(withName: "cat") as? CatNode {
            let catPosition = catNode.position

            let lerpFactor: CGFloat = 0.1

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
            addChild(newWall)
            
            wallGenerateTrigger += frame.size.height * 0.3
        }
    }
}

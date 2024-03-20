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
    var touchStart: CGPoint?
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        
        let floorSize = CGSize(width: frame.width, height: 125)
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
        
        addChild(cameraNode)
        addChild(normalWall1)
        addChild(normalWall2)
        addChild(normalWall3)
        addChild(floorNode)
        addChild(catNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let camera = cameraNode else { return }
        touchStart = touch.location(in: camera)
        
        if let catNode = childNode(withName: "cat") as? CatNode, catNode.canJump {
            let catShouldStop = !(catNode.currentWallMaterial.value == WallMaterial.glass)
            catNode.physicsBody?.velocity = .zero
            catNode.physicsBody?.isDynamic = false
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart, let camera = cameraNode else { return }
        let location = touch.location(in: camera)

        var dx = start.x - location.x
        var dy = start.y - location.y

        let magnitude = sqrt(dx * dx + dy * dy)

        let maxMagnitude: CGFloat = 125.0
        let minMagnitude: CGFloat = 10.0
        let clampedMagnitude = min(maxMagnitude, max(minMagnitude, magnitude))

        dx /= magnitude
        dy /= magnitude
        dx *= clampedMagnitude
        dy *= clampedMagnitude

        if let catNode = childNode(withName: "cat") as? CatNode, catNode.canJump {
            catNode.physicsBody?.isDynamic = true
            catNode.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
            catNode.currentWallMaterial.value = .none
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.wall) ||
           (bodyA.categoryBitMask == PhysicsCategory.wall && bodyB.categoryBitMask == PhysicsCategory.player) {

            let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode
            let wallNode = (bodyA.categoryBitMask == PhysicsCategory.wall ? bodyA.node : bodyB.node) as? WallNode

            if let catNode = catNode, let wallNode = wallNode {
                catNode.currentWallMaterial.value = wallNode.material
            }
        }
        
        if (bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.floor) ||
           (bodyA.categoryBitMask == PhysicsCategory.floor && bodyB.categoryBitMask == PhysicsCategory.player) {

            let catNode = (bodyA.categoryBitMask == PhysicsCategory.player ? bodyA.node : bodyB.node) as? CatNode

            if let catNode = catNode {
                catNode.currentWallMaterial.value = .normal
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PhysicsCategory.player | PhysicsCategory.floor ||
           contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PhysicsCategory.player | PhysicsCategory.wall {

            let catNode = (contact.bodyA.categoryBitMask == PhysicsCategory.player ? contact.bodyA.node 
                           : contact.bodyB.node) as? CatNode
            
            catNode?.currentWallMaterial.value = .none
        }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
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
}

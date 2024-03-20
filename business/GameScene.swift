//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var touchStart: CGPoint?
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        let floorSize = CGSize(width: frame.width, height: 125)
        let floorNode = FloorNode(size: floorSize)
        floorNode.position = CGPoint(x: frame.midX, y: frame.minY + floorSize.height / 2)

        let normalWall1 = WallNode(size: CGSize(width: 350, height: 700), material: .normal)
        normalWall1.position = CGPoint(x: frame.midX + 200, y: -frame.height * 0.4)
        
        let normalWall2 = WallNode(size: CGSize(width: 200, height: 1000), material: .normal)
        normalWall2.position = CGPoint(x: frame.midX - 200, y: frame.height * 0.4)
        
        let normalWall3 = WallNode(size: CGSize(width: 200, height: 500), material: .normal)
        normalWall3.position = CGPoint(x: frame.midX + 200, y: frame.height * 0.2)
        
        let catNode = CatNode(size: CGSize(width: 50, height: 50))
        catNode.position = CGPoint(x: frame.midX - 50, y: -frame.height * 0.25)
        
        addChild(normalWall1)
        addChild(normalWall2)
        addChild(normalWall3)
        addChild(floorNode)
        addChild(catNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStart = touch.location(in: self)
        
        if let catNode = childNode(withName: "cat") as? CatNode, catNode.canJump {
            catNode.physicsBody?.velocity = catNode.currentWallMaterial.value == WallMaterial.glass ? CGVector(dx: 0, dy: -2) : .zero
            catNode.physicsBody?.isDynamic = false
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart else { return }
        let location = touch.location(in: self)

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

}

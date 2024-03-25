//
//  CucumberSpriteComponent.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit
import SpriteKit

class CucumberSpriteComponent: GKComponent, GKAgentDelegate {
    let node: SKShapeNode
    
    init(size: CGSize) {
        node = SKShapeNode(rectOf: size)
        
        super.init()
        node.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        node.fillColor = .green

        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        node.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        node.name = "enemyCucumber"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

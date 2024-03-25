//
//  CatComponent.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import SpriteKit
import GameplayKit

class CatSpriteComponent: GKComponent {
    let node: SKShapeNode
    
    var canJump: Bool = true
    var currentWallMaterial: WallMaterial = .none {
        didSet {
            canJump = currentWallMaterial != .none
        }
    }
    
    init(size: CGSize) {
        node = SKShapeNode(rectOf: size)
        super.init()
        
        node.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        node.fillColor = .blue
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 0.8, height: size.height))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.wall | PhysicsCategory.enemy
        node.physicsBody?.usesPreciseCollisionDetection = true
        
        node.name = "cat"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

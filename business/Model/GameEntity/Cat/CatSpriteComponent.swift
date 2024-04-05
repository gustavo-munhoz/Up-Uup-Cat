//
//  CatComponent.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import SpriteKit
import GameplayKit

class CatSpriteComponent: GKComponent {
    let node: SKSpriteNode
    
    var canJump: Bool = true
    var currentWallMaterial: WallMaterial = .normal {
        didSet {
            canJump = currentWallMaterial != .none
        }
    }
    
    init(size: CGSize) {
        node = SKSpriteNode(texture: GC.PLAYER.TEXTURE.START, size: size)
        super.init()
        
        node.physicsBody = SKPhysicsBody(rectangleOf: size * 0.8)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.wall | PhysicsCategory.enemy
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.mass = GC.PLAYER.DEFAULT_MASS
        
        node.name = "cat"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

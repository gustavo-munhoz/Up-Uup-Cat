//
//  CucumberSpriteComponent.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit
import SpriteKit

class CucumberSpriteComponent: GKComponent, GKAgentDelegate {
    let node: SKSpriteNode
    
    private var animation = SKAction.repeatForever(
        SKAction.animate(
            with: [GC.CUCUMBER.TEXTURE.CHASING_FRAME_1, GC.CUCUMBER.TEXTURE.CHASING_FRAME_2],
            timePerFrame: 1/8)
    )
    
    init(size: CGSize) {
        node = SKSpriteNode(texture: GC.CUCUMBER.TEXTURE.CHASING_FRAME_2, size: size)
        
        super.init()

        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        node.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        node.name = "enemyCucumber"
        
        node.run(animation)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

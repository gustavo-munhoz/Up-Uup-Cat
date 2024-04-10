//
//  Collectible.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 09/04/24.
//

import SpriteKit

enum Collectible: String {
    case nigiri = "nigiri_collectible"
    case catnip = "catnip_collectible"
}

class CollectibleNode: SKSpriteNode {
    let type: Collectible
    
    init(collectible c: Collectible) {
        self.type = c
        
        super.init(
            texture: SKTexture(imageNamed: c.rawValue),
            color: .clear,
            size: c == .catnip ? CGSize(width: 51, height: 70) : CGSize(width: 79, height: 51)
        )
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.collectible
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = false
        
        name = c.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

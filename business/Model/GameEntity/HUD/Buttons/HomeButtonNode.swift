//
//  HomeButtonNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 15/04/24.
//

import SpriteKit

class HomeButtonNode: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "homeButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

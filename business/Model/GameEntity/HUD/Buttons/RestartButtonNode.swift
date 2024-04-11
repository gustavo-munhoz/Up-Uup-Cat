//
//  RestartButtonNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 11/04/24.
//

import SpriteKit

class RestartButtonNode: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "restartButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

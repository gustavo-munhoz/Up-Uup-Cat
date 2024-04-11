//
//  WatchAdButtonNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 11/04/24.
//

import SpriteKit

class WatchAdButtonNode: SKSpriteNode {
    init(size: CGSize, isHighScore: Bool) {
        super.init(texture: SKTexture(imageNamed: "restartButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

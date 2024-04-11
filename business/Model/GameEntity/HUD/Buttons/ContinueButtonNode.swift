//
//  ContinueButtonNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 11/04/24.
//

import SpriteKit

class ContinueButtonNode: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "continueButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

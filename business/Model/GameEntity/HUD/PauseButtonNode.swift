//
//  PauseButtonNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 04/04/24.
//

import SpriteKit

class PauseButtonNode: SKSpriteNode {
    init(imageNamed imageName: String, size: CGSize) {
        super.init(texture: SKTexture(imageNamed: imageName), color: .clear, size: size)
        
        name = GC.HUD.PAUSE_BUTTON
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

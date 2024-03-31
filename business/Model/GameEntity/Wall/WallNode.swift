//
//  WallNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit

class WallNode: SKSpriteNode {
    var material: WallMaterial = .normal
    
    init(size: CGSize, material: WallMaterial) {
        self.material = material
        super.init(texture: nil, color: .clear, size: size)
        
        let aspectRatio = size.width / size.height
        
        if aspectRatio > 3 {
            texture = GC.WALL.TEXTURE.LONG
        } else if aspectRatio < 0.5 {
            texture = GC.WALL.TEXTURE.TALL
        } else if aspectRatio >= 0.8 && aspectRatio <= 1.2 {
            texture = GC.WALL.TEXTURE.SQUARE
        } else {
            texture = GC.WALL.TEXTURE.REGULAR
        }
        
        name = "wall"
        self.material = material
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

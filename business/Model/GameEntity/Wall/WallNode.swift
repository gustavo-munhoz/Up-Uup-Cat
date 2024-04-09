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
            switch material {
                case .none:
                    break
                    
                case .normal:
                    texture = GC.WALL.TEXTURE.NORMAL.LONG
                    break
                    
                case .glass:
//                    texture = GC.WALL.TEXTURE.GLASS.LONG
                    break
                    
                case .sticky:
                    break
//                    texture = GC.WALL.TEXTURE.STICKY.LONG
            }
        } else if aspectRatio < 0.5 {
            switch material {
                case .none:
                    break
                case .normal:
                    texture = GC.WALL.TEXTURE.NORMAL.TALL
                    break
                case .glass:
                    texture = GC.WALL.TEXTURE.GLASS.TALL
                    break
                case .sticky:
//                    texture = GC.WALL.TEXTURE.STICKY.TALL
                    break
            }
        } else if aspectRatio >= 0.8 && aspectRatio <= 1.2 {
            switch material {
                case .none:
                    break
                case .normal:
                    texture = GC.WALL.TEXTURE.NORMAL.SQUARE
                    break
                case .glass:
                    texture = GC.WALL.TEXTURE.GLASS.SQUARE
                    break
                case .sticky:
//                    texture = GC.WALL.TEXTURE.STICKY.SQUARE
                    break
            }
        } else {
            switch material {
                case .none:
                    break
                case .normal:
                    texture = GC.WALL.TEXTURE.NORMAL.REGULAR
                    break
                case .glass:
//                    texture = GC.WALL.TEXTURE.GLASS.REGULAR
                    break
                case .sticky:
//                    texture = GC.WALL.TEXTURE.STICKY.REGULAR
                    break
            }
        }
        
        name = "wall"
        self.material = material
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

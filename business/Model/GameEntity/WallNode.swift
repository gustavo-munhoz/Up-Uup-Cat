//
//  WallNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit

class WallNode: SKShapeNode {
    var material: WallMaterial = .normal
    
    init(size: CGSize, material: WallMaterial) {
        super.init()
        
        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        
        path = CGPath(rect: CGRect(origin: origin, size: size), transform: nil)
        
        name = "wall"
        
        self.material = material
        
        
        setupWallProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWallProperties() {
        switch material {
            case .normal:
                fillColor = .gray
                
            case .glass:
                fillColor = .blue
                
            case .sticky:
                fillColor = .green
                
            case .none:
                fillColor = .clear
                
        }
    }
}

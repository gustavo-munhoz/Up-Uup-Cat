//
//  WallNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit

class WallNode: SKShapeNode {
    var material: WallMaterial = .normal
    let id = UUID()
    
    init(size: CGSize, material: WallMaterial) {
        super.init()
        
        path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        name = "wall"
        
        self.material = material
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.wall
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
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

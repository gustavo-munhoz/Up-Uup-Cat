//
//  CatNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit

class CatNode: SKShapeNode {
    var currentWallMaterial: WallMaterial = .none {
        didSet {
            canJump = currentWallMaterial != .none
        }
    }

    var canJump: Bool = true
    
    init(size: CGSize) {
        super.init()
        
        path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        fillColor = .blue
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 0.8, height: size.height))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.wall
        physicsBody?.usesPreciseCollisionDetection = true
        
        name = "cat"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CatNode {
    func prepareForJump() {
        if canJump {
            physicsBody?.velocity = .zero
            physicsBody?.isDynamic = false
        }
    }
    
    func handleJump(from start: CGPoint, to end: CGPoint) {
        guard canJump else { return }
        
        var dx = start.x - end.x
        var dy = start.y - end.y
        
        let magnitude = sqrt(dx * dx + dy * dy)
        let maxMagnitude: CGFloat = 110.0
        let minMagnitude: CGFloat = 10.0
        let clampedMagnitude = min(maxMagnitude, max(minMagnitude, magnitude))
        
        dx /= magnitude
        dy /= magnitude
        dx *= clampedMagnitude
        dy *= clampedMagnitude
        
        physicsBody?.isDynamic = true
        physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy)) 
    }
}

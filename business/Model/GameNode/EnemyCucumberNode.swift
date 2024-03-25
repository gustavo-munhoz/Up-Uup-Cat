//
//  EnemyCucumberNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 22/03/24.
//

import SpriteKit

class EnemyCucumberNode: SKShapeNode {
    var target: SKShapeNode?
    
    init(size: CGSize) {
        super.init()
        
        path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        fillColor = .green
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        name = "enemyCucumber"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withTimeDelta timeDelta: TimeInterval) {
        guard let target = target else { return }
        
        let direction = CGVector(
            dx: target.position.x - position.x,
            dy: target.position.y - position.y
        )
        .normalized()
        
        let speed: CGFloat = 100
        let velocity = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
        
        position = CGPoint(x: position.x + velocity.dx * CGFloat(timeDelta), y: position.y + velocity.dy * CGFloat(timeDelta))
    }
    
    func applyForceToMoveToTarget() {
        guard let target = target else { return }

        let direction = CGVector(
            dx: target.position.x - position.x,
            dy: target.position.y - position.y
        ).normalized()

        let forceMagnitude: CGFloat = 35
        let force = CGVector(dx: direction.dx * forceMagnitude, dy: direction.dy * forceMagnitude)

        physicsBody?.applyForce(force)
    }
}

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx * dx + dy * dy)
        return CGVector(dx: dx / length, dy: dy / length)
    }
}

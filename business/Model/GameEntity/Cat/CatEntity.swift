//
//  CatEntity.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit

class CatEntity: GKEntity {
    let spriteComponent: CatSpriteComponent
    let agentComponent: AgentComponent
    
    var currentHeight: CGFloat = 0
    var maxHeight: CGFloat = 0
    
    init(size: CGSize) {
        spriteComponent = CatSpriteComponent(size: size)
        agentComponent = AgentComponent()
        super.init()
        
        addComponent(spriteComponent)
        addComponent(agentComponent)
        
        agentComponent.agent.maxSpeed = 0
        agentComponent.agent.maxAcceleration = 0
        agentComponent.agent.mass = 1.0
        
        agentComponent.agent.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeight(newHeight: CGFloat) {
        currentHeight = newHeight
        if newHeight > maxHeight {
            maxHeight = newHeight
        }
    }
    
    func calculateProgress() -> CGFloat {
        return min(maxHeight / GC.DIFFICULTY.MAX_DIFFICULTY_HEIGHT, 1.0)
    }
}

extension CatEntity {
    func prepareForJump() {
        if spriteComponent.canJump {
            spriteComponent.node.physicsBody?.velocity = .zero
            spriteComponent.node.physicsBody?.isDynamic = false
        }
    }
    
    func handleJump(from start: CGPoint, to end: CGPoint) {
        guard spriteComponent.canJump else { return }
        
        var dx = start.x - end.x
        var dy = start.y - end.y
        
        let magnitude = sqrt(dx * dx + dy * dy)
        let maxMagnitude: CGFloat = GC.PLAYER.DEFAULT_BOOST_MAX
        let minMagnitude: CGFloat = GC.PLAYER.DEFAULT_BOOST_MIN
        let clampedMagnitude = min(maxMagnitude, max(minMagnitude, magnitude))
        
        dx /= magnitude
        dy /= magnitude
        dx *= clampedMagnitude
        dy *= clampedMagnitude
        
        spriteComponent.node.physicsBody?.isDynamic = true
        spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
}

extension CatEntity: GKAgentDelegate {
    func agentWillUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else { return }

        agent2D.position = SIMD2(Float(spriteComponent.node.position.x), Float(spriteComponent.node.position.y))
    }
}

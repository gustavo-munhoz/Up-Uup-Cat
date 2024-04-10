//
//  CucumberEntity.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit

class CucumberEntity: GKEntity {
    var isJumpingAtPlayer = false
    let spriteComponent: CucumberSpriteComponent
    let agentComponent: AgentComponent

    init(size: CGSize) {
        spriteComponent = CucumberSpriteComponent(size: size)
        agentComponent = AgentComponent()
        agentComponent.agent.maxSpeed = GC.CUCUMBER.DEFAULT_MAX_SPEED
        agentComponent.agent.maxAcceleration = GC.CUCUMBER.DEFAULT_MAX_ACCELERATION
        agentComponent.agent.mass = GC.CUCUMBER.DEFAULT_MASS
        
        super.init()

        addComponent(spriteComponent)
        addComponent(agentComponent)

        agentComponent.agent.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTarget(_ target: GKAgent2D) {
        let behavior = GKBehavior()
        let goal = GKGoal(toInterceptAgent: target, maxPredictionTime: 1.0)
        behavior.setWeight(1, for: goal)
        agentComponent.agent.behavior = behavior
    }
    
    func updateSpeedAndAcceleration(basedOnProgress progress: CGFloat) {
        let clampedProgress = min(max(progress, 0.0), 1.0)

        let speedRange = GC.CUCUMBER.DEFAULT_MAX_SPEED - GC.CUCUMBER.DEFAULT_MIN_SPEED
        let newMaxSpeed = GC.CUCUMBER.DEFAULT_MIN_SPEED + Float(clampedProgress) * speedRange

        let accelerationRange = GC.CUCUMBER.DEFAULT_MAX_ACCELERATION - GC.CUCUMBER.DEFAULT_MIN_ACCELERATION
        let newMaxAcceleration = GC.CUCUMBER.DEFAULT_MIN_ACCELERATION + Float(clampedProgress) * accelerationRange

        agentComponent.agent.maxSpeed = newMaxSpeed
        agentComponent.agent.maxAcceleration = newMaxAcceleration
    }
}

extension CucumberEntity: GKAgentDelegate {
    func agentDidUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else { return }
        spriteComponent.node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
    }
}

extension CucumberEntity {
    func jumpAtPlayer(player: CatEntity) {
        if let physicsBody = spriteComponent.node.physicsBody {
            let playerNode = player.spriteComponent.node
            let direction = CGVector(
                dx: playerNode.position.x - spriteComponent.node.position.x,
                dy: playerNode.position.y - spriteComponent.node.position.y
            ).normalized()
            
            let jumpVelocity = direction * GC.CUCUMBER.JUMPING_SPEED
            
            physicsBody.velocity = jumpVelocity
            isJumpingAtPlayer = true
        }
    }
}

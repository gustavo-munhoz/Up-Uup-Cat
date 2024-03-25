//
//  CucumberEntity.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit

class CucumberEntity: GKEntity {
    let spriteComponent: CucumberSpriteComponent
    let agentComponent: AgentComponent

    init(size: CGSize) {
        spriteComponent = CucumberSpriteComponent(size: size)

        agentComponent = AgentComponent()
        
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
}

extension CucumberEntity: GKAgentDelegate {
    func agentDidUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else { return }
        spriteComponent.node.position = CGPoint(x: CGFloat(agent2D.position.x), y: CGFloat(agent2D.position.y))
    }
}

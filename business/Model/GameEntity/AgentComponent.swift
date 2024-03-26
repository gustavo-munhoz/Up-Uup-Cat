//
//  AgentComponent.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit

class AgentComponent: GKComponent {
    let agent = GKAgent2D()

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(_ position: CGPoint) {
        agent.position = vector_float2(Float(position.x), Float(position.y))
    }
}

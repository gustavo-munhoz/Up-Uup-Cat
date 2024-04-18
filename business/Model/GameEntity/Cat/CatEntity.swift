//
//  CatEntity.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import GameplayKit
import Combine

class CatEntity: GKEntity {
    let spriteComponent: CatSpriteComponent
    let agentComponent: AgentComponent
    
    var currentHeight: Int = 0
    var maxHeight: Int = 0
    
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
    
    func updateHeight(newHeight: Int) {
        currentHeight = newHeight
        if newHeight > maxHeight {
            maxHeight = newHeight
            GameManager.shared.updateHighScore(maxHeight)
        }
    }
    
    func calculateProgress() -> CGFloat {
        return min(CGFloat(maxHeight) / GC.DIFFICULTY.MAX_DIFFICULTY_HEIGHT, 1.0)
    }
}

extension CatEntity {
    func handleMovement(startingHeight: CGFloat, walls: [WallNode]) {
        self.updateHeight(newHeight: Int((self.spriteComponent.node.position.y - startingHeight) / 50))
        
        if spriteComponent.node.texture == GC.PLAYER.TEXTURE.HOLDING_WALL ||
            spriteComponent.node.texture == GC.PLAYER.TEXTURE.PREPARE
        {
            spriteComponent.node.run(GC.PLAYER.TEXTURE.ANIMATION.JUMP)
        }
        
        for wall in walls {
            let contactAreaWidth = wall.frame.width - self.spriteComponent.node.frame.width
            let contactAreaHeight = wall.frame.height - self.spriteComponent.node.frame.height

            let contactAreaOriginX = wall.position.x - contactAreaWidth / 2
            let contactAreaOriginY = wall.position.y - wall.frame.height / 2

            let contactAreaFrameInScene = CGRect(
                x: contactAreaOriginX,
                y: contactAreaOriginY,
                width: contactAreaWidth,
                height: contactAreaHeight
            )

            if self.spriteComponent.node.frame.intersects(contactAreaFrameInScene) { 
                self.spriteComponent.currentWallMaterial = wall.material
                return
            }
        }
        self.spriteComponent.currentWallMaterial = .none
    }
    
    func prepareForJump(hasStarted: Bool = true, isTouching: Bool = false) {
        if spriteComponent.canJump {
            if hasStarted {
                spriteComponent.node.texture = GC.PLAYER.TEXTURE.HOLDING_WALL
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
            else if isTouching {
                spriteComponent.node.texture = GC.PLAYER.TEXTURE.PREPARE
            }
            else {
                spriteComponent.node.texture = GC.PLAYER.TEXTURE.START
            }
            
            spriteComponent.node.physicsBody?.velocity = .zero
            spriteComponent.node.physicsBody?.isDynamic = spriteComponent.currentWallMaterial == .glass
            
            if spriteComponent.currentWallMaterial == .glass {
                spriteComponent.node.physicsBody?.applyForce(GC.GLASS_FORCE)
                spriteComponent.node.texture = GC.PLAYER.TEXTURE.JUMP_FRAME_1
            }
        }
    }
    
    func handleJump(from start: CGPoint, to end: CGPoint) {
        guard spriteComponent.canJump else { return }

        var dx = start.x - end.x
        var dy = start.y - end.y

        let magnitude = sqrt(dx * dx + dy * dy)
        let maxMagnitude: CGFloat = GC.PLAYER.DEFAULT_BOOST_MAX
        
        let normalizedMagnitude = min(1, magnitude / maxMagnitude)
        
        let adjustedMagnitude = pow(2, normalizedMagnitude) - 1
        
        let scaledMagnitude = adjustedMagnitude * maxMagnitude

        if magnitude != 0 {
            dx /= magnitude
            dy /= magnitude
        }
        dx *= scaledMagnitude
        dy *= scaledMagnitude

        spriteComponent.node.physicsBody?.isDynamic = true
        spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
        if spriteComponent.node.texture == GC.PLAYER.TEXTURE.JUMP_FRAME_1 {
            spriteComponent.node.run(GC.PLAYER.TEXTURE.ANIMATION.GLASS_JUMP)
        }
    }
    
    func collectItem(c: Collectible, execute callClosure: @escaping () -> Void = {}) {
        switch c {
            case .catnip:
                break
                
            case .nigiri:
                GameManager.shared.increaseNigiriCount()
                for i in 1...3 { UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: CGFloat(i)/3) }
                break
        }
        
        
        callClosure()
    }
}

extension CatEntity: GKAgentDelegate {
    func agentWillUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else { return }

        agent2D.position = SIMD2(Float(spriteComponent.node.position.x), Float(spriteComponent.node.position.y))
    }
}

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
    
    private var sfxCounter = 0
    
    var currentHeight: Int = 0
    var maxHeight: Int = 0
    
    var isPumpedUpByCatnip = CurrentValueSubject<Bool, Never>(false)
    private weak var catnipTimerWorkItem: DispatchWorkItem?
    
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
        let heightDifference = self.spriteComponent.node.position.y - startingHeight
        self.updateHeight(newHeight: Int(heightDifference / 50))
        
        if spriteComponent.node.texture == GC.PLAYER.TEXTURE.HOLDING_WALL
            || spriteComponent.node.texture == GC.PLAYER.TEXTURE.PREPARE
        {
            spriteComponent.node.run(GC.PLAYER.TEXTURE.ANIMATION.JUMP)
        }

        var isContactMade = false
        for wall in walls {
            guard let contactArea = wall.contactArea else { continue }
            
            if spriteComponent.node.frame.intersects(contactArea) {
                self.spriteComponent.currentWallMaterial = wall.material
                isContactMade = true
                break
            }
        }
        
        if !isContactMade {
            self.spriteComponent.currentWallMaterial = .none
        }
    }
    
    func prepareForJump(hasStarted: Bool = true, isTouching: Bool = false) {
        if spriteComponent.canJump {
            if hasStarted {
                spriteComponent.node.texture = GC.PLAYER.TEXTURE.HOLDING_WALL
                HapticsManager.playRigidImpact()
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
        
    
        SoundEffect.jump.playIfAllowed()

        var dx = start.x - end.x
        var dy = start.y - end.y

        let magnitude = sqrt(dx * dx + dy * dy)
        let maxMagnitude: CGFloat = isPumpedUpByCatnip.value ? GC.PLAYER.PUMPED_BOOST_MAX : GC.PLAYER.DEFAULT_BOOST_MAX

        if magnitude != 0 {
            let normalizedMagnitude = min(1, magnitude / maxMagnitude)
            let adjustedMagnitude = pow(2, normalizedMagnitude) - 1
            let scaledMagnitude = adjustedMagnitude * maxMagnitude
            
            dx *= scaledMagnitude / magnitude
            dy *= scaledMagnitude / magnitude

            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))

            if spriteComponent.node.texture == GC.PLAYER.TEXTURE.JUMP_FRAME_1 {
                spriteComponent.node.run(GC.PLAYER.TEXTURE.ANIMATION.GLASS_JUMP)
            }
        }
    }

    
    func collectItem(c: Collectible, execute callClosure: @escaping () -> Void = {}) {
        switch c {
            case .catnip:
                SoundEffect.pickUpCatnip.playIfAllowed()
                setPumpedUpState(true, for: 5)
                HapticsManager.playHeavyImpact()
                break
                
            case .nigiri:
                SoundEffect.pickUpNigiri.playIfAllowed()
                GameManager.shared.increaseNigiriCount()
                HapticsManager.playSoftImpact()
                break
        }
        
        callClosure()
    }
    
    private func setPumpedUpState(_ state: Bool, for duration: TimeInterval) {
        catnipTimerWorkItem?.cancel()
        
        isPumpedUpByCatnip.value = state

        let workItem = DispatchWorkItem {
            self.isPumpedUpByCatnip.value = false
        }
        
        catnipTimerWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }
}

extension CatEntity: GKAgentDelegate {
    func agentWillUpdate(_ agent: GKAgent) {
        guard let agent2D = agent as? GKAgent2D else { return }

        agent2D.position = SIMD2(Float(spriteComponent.node.position.x), Float(spriteComponent.node.position.y))
    }
}

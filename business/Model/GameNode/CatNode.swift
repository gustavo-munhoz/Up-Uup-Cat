//
//  CatNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import Combine

class CatNode: SKShapeNode {
    var currentWallMaterial: CurrentValueSubject<WallMaterial, Never> = CurrentValueSubject(.none)
    private var cancellables = Set<AnyCancellable>()
    @Published var canJump: Bool = false
    
    init(size: CGSize) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .blue
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.wall | PhysicsCategory.floor
        self.physicsBody?.collisionBitMask = PhysicsCategory.floor
        
        self.name = "cat"
        
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        currentWallMaterial
            .map { $0 != .none }
            .assign(to: \.canJump, on: self)
            .store(in: &cancellables)
    }
}


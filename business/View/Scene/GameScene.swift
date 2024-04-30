//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit
import Combine
import FirebaseAnalytics

import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate {
    /// Transforms the CG expression to a relative value
    private lazy var t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
    
    var canStart = false
    
    var cancellables = Set<AnyCancellable>()
    
    var hasStarted = false {
        didSet {
            if hasStarted {
                AnalyticsService.logEventGameStarted()
                cucumberEntity.spriteComponent.node.isHidden = false
            }
        }
    }
    
    var isGameOver = false {
        didSet {
            if isGameOver { AnalyticsService.logEventGameOver() }
        }
    }
    
    var hasGeneratedFirstWalls = false
    
    var cameraManager: CameraManager!
    var zoomOutTimer: Timer?
    
    
    var wallFactory: WallFactory!
    var existingWalls: [WallNode] = []
    var lastWallTopY: CGFloat!
    
    var catEntity: CatEntity!
    var cucumberEntity: CucumberEntity!
    var lastUpdateTime: TimeInterval = 0
    var startingHeight: CGFloat!
    
    var arrowNode: ArrowNode?
    var hud: HUDNode!
    
    
    var isGrabbingGlass = false {
        didSet {
            if isGrabbingGlass {
                SoundEffect.squeakingGlass.playIfAllowed()
            } else {
                SoundEffect.squeakingGlass.stop()
            }
        }
    }
    
    var sceneSetupManager: SceneSetupManager!
    var sceneTouchManager: SceneTouchManager!
    var sceneContactManager: SceneContactManager!
    var sceneUpdateManager: SceneUpdateManager!
    
    var cucumberShouldJump: Bool {
        catEntity.spriteComponent.node.position.y < -frame.minY
        || catEntity.spriteComponent.node.position.x < -frame.width * 2
        || catEntity.spriteComponent.node.position.x > frame.width * 2
    }
    
    var gameShouldEnd: Bool {
        catEntity.spriteComponent.node.position.y < -frame.minY
        || catEntity.spriteComponent.node.position.x < -frame.width * 2
        || catEntity.spriteComponent.node.position.x > frame.width * 2
        || catEntity.spriteComponent.node.physicsBody!.velocity.dy <= -4000
    }
    
    // MARK: - Scene setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.sceneSetupManager = SceneSetupManager(scene: self, frame: frame)
        self.sceneTouchManager = SceneTouchManager(scene: self)
        self.sceneContactManager = SceneContactManager(scene: self)
        self.sceneUpdateManager = SceneUpdateManager(scene: self)
        
        sceneSetupManager.setupScene()
        sceneSetupManager.animateCameraIntro()
        
        setupSubscriptions()
    }
    
    // MARK: - Default methods

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouchManager.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouchManager.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouchManager.touchesEnded(touches, with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        sceneUpdateManager.handleUpdate(currentTime: currentTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        sceneContactManager.handleContact(contact)
    }
}

// MARK: - Custom methods
extension GameScene {
    func setupSubscriptions() {
        catEntity.isPumpedUpByCatnip.sink { isPumped in
            if !isPumped && self.hasStarted {
                self.cameraManager.adjustScale(progress: self.catEntity.calculateProgress())
            }
        }
        .store(in: &cancellables)
    }
    
    func handleCatMovement() {
        guard !isGameOver else { return }
        
        catEntity.handleMovement(startingHeight: startingHeight, walls: existingWalls)
        
        if !isGameOver, catEntity.currentHeight >= catEntity.maxHeight {
            hud.updateCurrentScore(catEntity.maxHeight)
            cucumberEntity.updateSpeedAndAcceleration(basedOnProgress: catEntity.calculateProgress())
        }
    }
    
    func handleWallGeneration() {
        wallFactory.adjustWallParameters(forProgress: catEntity.calculateProgress())
        
        if cameraManager.cameraNode.position.y * cameraManager.currentScale + (frame.size.height * 0.5) > wallFactory.lastWallMaxY {
            let walls = wallFactory.createWalls()
            
            for wall in walls {
                existingWalls.append(wall)
                wall.zPosition = 1
                addChild(wall)
            }
        }
    }
    
    func handleCucumberMovement(currentTime: TimeInterval) {
        if !isGameOver && gameShouldEnd {
            handleCatDeath()
            return
        }
        
        cucumberEntity.updateTarget(catEntity.agentComponent.agent)
        var deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if deltaTime > 0.02 {
            deltaTime = 0.02
        }
        
        cucumberEntity.agentComponent.agent.update(deltaTime: deltaTime)
        catEntity.agentComponent.agent.update(deltaTime: deltaTime)
        
        let distance = distanceBetween(
            cucumberEntity.spriteComponent.node.position,
            catEntity.spriteComponent.node.position
        )
        
        let volume = calculateVolumeBasedOnDistance(distance)
        
        SoundEffect.wingFlap.playIfAllowed(withVolume: volume)
    }
    
    func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }

    func calculateVolumeBasedOnDistance(_ distance: CGFloat) -> Float {
        let maxDistance: CGFloat = 2500
        let volume = max(0, 1 - (distance / maxDistance))
        return Float(volume)
    }
    
    func handleCatDeath() {
        guard !isGameOver else { return }
        
        let deathSequence = GC.PLAYER.TEXTURE.ANIMATION().DEATH
        
        // Avoid that other animations interfere with cat texture
        catEntity.spriteComponent.node.removeAllActions()
        
        
        SoundEffect.catScream.playIfAllowed()
        catEntity.spriteComponent.node.run(deathSequence) {
            GameManager.shared.endGame()
        }
        
        isGameOver = true
    }
}

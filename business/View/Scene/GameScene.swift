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
    
    var wallFactory: WallFactory!
    var existingWalls: [WallNode] = []
    var lastWallTopY: CGFloat!
    
    var catEntity: CatEntity!
    var cucumberEntity: CucumberEntity!
    var lastUpdateTime: TimeInterval = 0
    var startingHeight: CGFloat!
    
    var arrowNode: ArrowNode?
    var hud: HUDNode!
    var pauseScreen: PauseScreen!
    var gameOverScreen: GameOverScreen!
    
    var isGrabbingGlass = false
    
    var zoomOutTimer: Timer?
    
    var sceneSetupManager: SceneSetupManager!
    var sceneTouchManager: SceneTouchManager!
    var sceneContactManager: SceneContactManager!
    var sceneUpdateManager: SceneUpdateManager!
    
    var cucumberShouldJump: Bool {
        get {
            if let vy = catEntity.spriteComponent.node.physicsBody?.velocity.dy, vy < -2250 ||
                catEntity.spriteComponent.node.position.y < -frame.minY ||
                catEntity.spriteComponent.node.position.x < -frame.width * 2 ||
                catEntity.spriteComponent.node.position.x > frame.width * 2
            {
                return true
            } 
            else { return false }
        }
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
            
    }
    
    // MARK: - Default methods

    @objc func appDidBecomeActive() {
        // TODO: FIX LEAVING THE APP AND COMING BACK
//        if !isPaused {
//            togglePause()
//        }
    }
    
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
        GameManager.shared.shouldAnimateDoubleNigiris.sink { values in
            self.animateDoubleNigiri(start: values[0], end: values[1])
        }
        .store(in: &cancellables)
    }
    
    func animateDoubleNigiri(start startValue: Int, end endValue: Int) {
        let steps = abs(endValue - startValue)
        let timePerStep = 2 / Double(steps)
        
        var currentStep = 0
        let action = SKAction.run {
            self.gameOverScreen.nigiriBalanceLabel.text = "\(startValue + currentStep)"
            currentStep += 1
        }
        
        let wait = SKAction.wait(forDuration: timePerStep)
        let sequence = SKAction.sequence([action, wait])
        let repeatAction = SKAction.repeat(sequence, count: steps)
        
        gameOverScreen.nigiriBalanceLabel.run(repeatAction)
    }
    
    func handleCatMovement() {
        catEntity.handleMovement(startingHeight: startingHeight, walls: existingWalls)
        
        if !isGameOver, catEntity.currentHeight >= catEntity.maxHeight {
            hud.updateCurrentScore(catEntity.maxHeight)
            pauseScreen.update(withScore: catEntity.maxHeight)
            gameOverScreen.update(withScore: catEntity.maxHeight)
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
        if cucumberShouldJump && !isGameOver { cucumberEntity.jumpAtPlayer(player: catEntity) }
        
        else if !cucumberEntity.isJumpingAtPlayer {
            cucumberEntity.updateTarget(catEntity.agentComponent.agent)
            var deltaTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            
            if deltaTime > 0.02 {
                deltaTime = 0.02
            }
            
            cucumberEntity.agentComponent.agent.update(deltaTime: deltaTime)
            catEntity.agentComponent.agent.update(deltaTime: deltaTime)
        }
    }
    
    func togglePause() {
        isPaused.toggle()
        pauseScreen.isHidden.toggle()
    }
    
    func showGameOverScreen() {
        gameOverScreen?.removeFromParent()
        
        gameOverScreen = GameOverScreen()
        gameOverScreen.setup(
            withFrame: frame,
            isHighScore: GameManager.shared.currentScore.value > GameManager.shared.personalBestScore
        )
        
        gameOverScreen.isHidden = false
        
        cameraManager.cameraNode.addChild(gameOverScreen)
        
        GameManager.shared.saveStats()
    }
    
    func handleCatDeath() {
        guard !isGameOver else { return }
        
        let deathSequence = GC.PLAYER.TEXTURE.ANIMATION().DEATH
        
        // Avoid that other animations interfere with cat texture
        catEntity.spriteComponent.node.removeAllActions()
        
        catEntity.spriteComponent.node.run(deathSequence) {
            self.showGameOverScreen()
        }
        
        isGameOver = true
    }
}

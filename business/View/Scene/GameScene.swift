//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /// Transforms the CG expression to a relative value
    private lazy var t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
    
    var hasStarted = false
    var isGameOver = false
    
    var cameraManager: CameraManager!
    var touchStart: CGPoint?
    
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
    
    var touchStartedOnButton = false
    
    // MARK: - Scene setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupCamera()
        setupPhysicsWorld()
        setupEntities()
        setupHUD()
    }
    
    func setupBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "roof_background_start")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = CGSize(width: 4 * frame.width, height: frame.height)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
    }

    func setupPhysicsWorld() {
        physicsWorld.gravity = GC.GRAVITY
        physicsWorld.contactDelegate = self
    }

    func setupCamera() {
        cameraManager = CameraManager(frame: frame, minimumHeight: frame.midY * 1.05)
        self.camera = cameraManager.cameraNode
        addChild(cameraManager.cameraNode)
        
        let background = SKSpriteNode(imageNamed: "background_gradient")
        background.size = frame.size
        background.position = CGPoint(x: frame.minX, y: frame.minY)
        background.zPosition = -2
        
        cameraManager.cameraNode.addChild(background)
    }

    func setupEntities() {
        setupCatEntity()
        setupCucumberEntity()
        wallFactory = WallFactory(frame: frame, cameraPositionY: cameraManager.cameraNode.position.y, firstWallsHeight: frame.height * 0.5)
    }

    func setupCatEntity() {
        catEntity = CatEntity(size: CGSize(width: 76, height: 109).applying(t))
        guard let catNode = catEntity.component(ofType: CatSpriteComponent.self)?.node else { return }
        catNode.position = CGPoint(x: frame.midX, y: frame.midY)
        catNode.zPosition = 2
        addChild(catNode)
        catEntity.prepareForJump()
        startingHeight = catEntity.spriteComponent.node.position.y
        catEntity.agentComponent.setPosition(catEntity.spriteComponent.node.position)
    }

    func setupCucumberEntity() {
        cucumberEntity = CucumberEntity(size: CGSize(width: 62, height: 84).applying(t))
        guard let cucumberNode = cucumberEntity.component(ofType: CucumberSpriteComponent.self)?.node else { return }
        cucumberNode.position = CGPoint(x: frame.minX + 50, y: -frame.height * 0.5)
        cucumberNode.zPosition = 5
        cucumberEntity.agentComponent.setPosition(cucumberEntity.spriteComponent.node.position)
        
        addChild(cucumberNode)        
    }
    
    func setupHUD() {
        hud = HUDNode()
        hud.setup(withFrame: frame)
        cameraManager.cameraNode.addChild(hud)
        
        pauseScreen = PauseScreen()
        pauseScreen.setup(withFrame: frame)
        pauseScreen.isHidden = true
        cameraManager.cameraNode.addChild(pauseScreen)
        
        gameOverScreen = GameOverScreen()
        gameOverScreen.setup(withFrame: frame)
        gameOverScreen.isHidden = true
        cameraManager.cameraNode.addChild(gameOverScreen)
    }
    
    // MARK: - Default methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStart = touch.location(in: cameraManager.cameraNode)
        
        guard let touchStart = touchStart else { return }
        
        if hud.pauseButton.contains(touchStart) && !isGameOver {
            touchStartedOnButton = true
            hud.pauseButton.alpha = 0.5
            
        } 
        
        else if pauseScreen.continueButton.contains(touchStart) && !isGameOver {
            touchStartedOnButton = true
            pauseScreen.continueButton.alpha = 0.5
            
        } 
        
        else if gameOverScreen.restartButton.contains(touchStart) {
            touchStartedOnButton = true
            gameOverScreen.restartButton.alpha = 0.5
        }
        
        else {
            guard catEntity.spriteComponent.currentWallMaterial != .none, !isPaused else { return }
            
            createArrowNode()
            catEntity.prepareForJump()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touchStartedOnButton, let touch = touches.first, let start = touchStart else { return }
        let touchLocation = touch.location(in: cameraManager.cameraNode)
        arrowNode?.update(start: start, end: touchLocation)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart else { return }
        
        let location = touch.location(in: cameraManager.cameraNode)
        
        if touchStartedOnButton {
            if hud.pauseButton.contains(location) && !isPaused && !isGameOver {
                hud.pauseButton.alpha = 1
                togglePause()
            } 
            
            else if pauseScreen.continueButton.contains(location) && isPaused && !isGameOver {
                pauseScreen.continueButton.alpha = 1
                togglePause()
            }
            
            else if gameOverScreen.restartButton.contains(location) {
                GameManager.shared.resetGame()
            }

            touchStartedOnButton = false
            return
        }
        
        if !hasStarted { hasStarted = true }
        
        catEntity.handleJump(from: start, to: location)
        
        arrowNode?.removeFromParent()
        arrowNode = nil
    }


    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        cameraManager.updateCameraPosition(catEntity: catEntity)
        
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        
        if hasStarted { handleCucumberMovement(currentTime: currentTime) }
        else { handleWallGeneration() }
        
        guard catEntity.spriteComponent.node.physicsBody?.velocity != .zero else { return }

        handleCatMovement()
        
        handleWallGeneration()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if bodyA.node?.name == "cat" && bodyB.node?.name == "enemyCucumber"
            || bodyA.node?.name == "enemyCucumber" && bodyB.node?.name == "cat"
        {
            cucumberEntity.isJumpingAtPlayer = false
            
            if gameOverScreen.isHidden {
                showGameOverScreen()
            }
        }
    }
}

// MARK: - Custom methods
extension GameScene {
    func handleCatMovement() {
        catEntity.handleMovement(startingHeight: startingHeight, walls: existingWalls)
        
        if catEntity.currentHeight >= catEntity.maxHeight {
            hud.updateCurrentScore(catEntity.maxHeight)
            pauseScreen.update(withScore: catEntity.maxHeight)
            gameOverScreen.update(withScore: catEntity.maxHeight)
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
        if let vy = catEntity.spriteComponent.node.physicsBody?.velocity.dy, vy < -2000 ||
            catEntity.spriteComponent.node.position.y < -frame.minY
        {
            cucumberEntity.jumpAtPlayer(player: catEntity)
        } 
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
    
    private func createArrowNode() {
        arrowNode = ArrowNode(
            catPosition: CGPoint(
                x: catEntity.spriteComponent.node.position.x,
                y: catEntity.spriteComponent.node.position.y + catEntity.spriteComponent.node.frame.height/2
            )
        )
        
        addChild(arrowNode!)
    }
    
    func togglePause() {
        isPaused.toggle()
        pauseScreen.isHidden.toggle()
    }
    
    func showGameOverScreen() {
        isPaused = true
        isGameOver = true
        gameOverScreen.isHidden = false
    }
}

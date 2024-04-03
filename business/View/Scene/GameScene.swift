//
//  GameScene.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var hasStarted = false
    
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
    
    var maxHeightLabel: SKLabelNode!
    
    // MARK: - Scene setup
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupCamera()
        setupPhysicsWorld()
        setupEntities()
        setupUI()
    }
    
    func setupBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "background_start")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = self.frame.size
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
    }

    func setupPhysicsWorld() {
        physicsWorld.gravity = GC.GRAVITY
        physicsWorld.contactDelegate = self
    }

    func setupCamera() {
        cameraManager = CameraManager(frame: frame)
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
        wallFactory = WallFactory(frame: frame, cameraPositionY: cameraManager.cameraNode.position.y)
    }

    func setupCatEntity() {
        catEntity = CatEntity(size: CGSize(width: 98, height: 141))
        guard let catNode = catEntity.component(ofType: CatSpriteComponent.self)?.node else { return }
        catNode.position = CGPoint(x: frame.midX, y: frame.midY)
        catNode.zPosition = 2
        addChild(catNode)
        catEntity.prepareForJump()
        startingHeight = catEntity.spriteComponent.node.position.y
        catEntity.agentComponent.setPosition(catEntity.spriteComponent.node.position)
    }

    func setupCucumberEntity() {
        cucumberEntity = CucumberEntity(size: CGSize(width: 120, height: 165))
        guard let cucumberNode = cucumberEntity.component(ofType: CucumberSpriteComponent.self)?.node else { return }
        cucumberNode.position = CGPoint(x: frame.minX + 50, y: -frame.height * 0.5)
        cucumberNode.zPosition = 5
        cucumberEntity.agentComponent.setPosition(cucumberEntity.spriteComponent.node.position)
        
        addChild(cucumberNode)        
    }

    func setupUI() {
        let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.size = CGSize(width: 56, height: 76)
        pauseButton.position = CGPoint(x: -frame.maxX * 0.6, y: frame.maxY * 0.8)
        pauseButton.zPosition = 100
        pauseButton.name = "pauseButton"
        cameraManager.cameraNode.addChild(pauseButton)
        
        let highScoreLabelTitle = SKLabelNode(fontNamed: "Urbanist-Medium")
        highScoreLabelTitle.fontSize = 24
        highScoreLabelTitle.fontColor = .white
        highScoreLabelTitle.text = "top"
        highScoreLabelTitle.position = CGPoint(x: frame.maxX * 0.6, y: pauseButton.position.y * 0.96)
        highScoreLabelTitle.zPosition = 100
        cameraManager.cameraNode.addChild(highScoreLabelTitle)
        
        let highScoreLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        highScoreLabel.fontSize = 24
        highScoreLabel.fontColor = .white
        highScoreLabel.text = "\(GameManager.shared.currentHighScore) m"
        highScoreLabel.position = CGPoint(x: frame.maxX * 0.6, y: pauseButton.position.y * 0.91)
        highScoreLabel.zPosition = 100
        cameraManager.cameraNode.addChild(highScoreLabel)
        
        maxHeightLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        maxHeightLabel.fontSize = 48
        maxHeightLabel.fontColor = .white
        maxHeightLabel.horizontalAlignmentMode = .right
        maxHeightLabel.verticalAlignmentMode = .top
        maxHeightLabel.position = CGPoint(x: highScoreLabel.position.x * 0.8, y: pauseButton.position.y)
        maxHeightLabel.text = "\(catEntity.maxHeight)"
        maxHeightLabel.zPosition = 100
        cameraManager.cameraNode.addChild(maxHeightLabel)
        
        let nigiriCountLabel = SKLabelNode(fontNamed: "Urbanist-BoldItalic")
        nigiriCountLabel.fontSize = 42
        nigiriCountLabel.fontColor = .white
        nigiriCountLabel.text = "soon"
        nigiriCountLabel.position = CGPoint(x: maxHeightLabel.position.x * 0.9, y: highScoreLabel.position.y * 0.9)
        nigiriCountLabel.zPosition = 100
        cameraManager.cameraNode.addChild(nigiriCountLabel)
        
                
        let nigiriSprite = SKSpriteNode(imageNamed: "nigiri_score")
        nigiriSprite.size = CGSize(width: 56, height: 38)
        nigiriSprite.position = CGPoint(x: highScoreLabel.position.x, y: highScoreLabel.position.y * 0.93)
        nigiriSprite.zPosition = 100
        
        cameraManager.cameraNode.addChild(nigiriSprite)
        
        let highScoreLabelTitleShadow = createShadowLabelNode(for: highScoreLabelTitle, offset: CGPoint(x: 2, y: -2), color: .black, blur: 0.15)
        cameraManager.cameraNode.addChild(highScoreLabelTitleShadow)

        let highScoreLabelShadow = createShadowLabelNode(for: highScoreLabel, offset: CGPoint(x: 2, y: -2), color: .black, blur: 0.15)
        cameraManager.cameraNode.addChild(highScoreLabelShadow)

        let maxHeightLabelShadow = createShadowLabelNode(for: maxHeightLabel, offset: CGPoint(x: -maxHeightLabel.frame.width * 2.25, y: -40), color: .black, blur: 0.15)
        maxHeightLabelShadow.name = "maxHeightShadow"
        cameraManager.cameraNode.addChild(maxHeightLabelShadow)

        let nigiriCountLabelShadow = createShadowLabelNode(for: nigiriCountLabel, offset: CGPoint(x: 2, y: -2), color: .black, blur: 0.15)
        cameraManager.cameraNode.addChild(nigiriCountLabelShadow)
    }
    
    
    // MARK: - Default methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStart = touch.location(in: cameraManager.cameraNode)
        
        guard catEntity.spriteComponent.currentWallMaterial != .none else { return }
        
        createArrowNode()
        catEntity.prepareForJump()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart else { return }
        let touchLocation = touch.location(in: cameraManager.cameraNode)
        
        arrowNode?.update(start: start, end: touchLocation)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let start = touchStart else { return }
        
        if !hasStarted { hasStarted = true }
        
        let location = touch.location(in: cameraManager.cameraNode)
        
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
        
        catEntity.handleMovement(startingHeight: startingHeight, walls: existingWalls)
        
        if maxHeightLabel != nil {
            maxHeightLabel.text = "\(catEntity.maxHeight) m"
            
            if let shadowNode = cameraManager.cameraNode.childNode(withName: "maxHeightShadow") as? SKLabelNode {
                shadowNode.text = maxHeightLabel.text
            }
        }
        
        handleWallGeneration()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = (contact.bodyA, contact.bodyB)
        
        if bodyA.node?.name == "cat" && bodyB.node?.name == "enemyCucumber"
            || bodyA.node?.name == "enemyCucumber" && bodyB.node?.name == "cat"
        {
            cucumberEntity.isJumpingAtPlayer = false
            GameManager.shared.resetGame()
        }
    }
}

// MARK: - Custom methods
extension GameScene {
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
        if let vy = catEntity.spriteComponent.node.physicsBody?.velocity.dy, vy < -2000 {
            cucumberEntity.jumpAtPlayer(player: catEntity)
            
        } else if !cucumberEntity.isJumpingAtPlayer {
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
    
    func createShadowLabelNode(for label: SKLabelNode, offset: CGPoint, color: UIColor, blur: CGFloat) -> SKLabelNode {
        let shadowLabel = SKLabelNode(fontNamed: label.fontName)
        shadowLabel.text = label.text
        shadowLabel.fontSize = label.fontSize
        shadowLabel.fontColor = color.withAlphaComponent(blur)
        shadowLabel.position = CGPoint(x: label.position.x + offset.x, y: label.position.y + offset.y)
        shadowLabel.zPosition = label.zPosition - 1
        return shadowLabel
    }
}

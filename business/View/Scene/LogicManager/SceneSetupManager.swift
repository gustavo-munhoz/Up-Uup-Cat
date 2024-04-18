//
//  SceneSetupManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 16/04/24.
//

import SpriteKit

class SceneSetupManager {
    weak var scene: GameScene?
    let frame: CGRect

    init(scene: GameScene, frame: CGRect) {
        self.scene = scene
        self.frame = frame
    }

    func setupScene() {
        setupBackground()
        setupPhysicsWorld()
        setupCamera()
        setupEntities()
        setupHUD()
    }

    private func setupBackground() {
        let backgroundImage = SKSpriteNode(imageNamed: "roof_background_start")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = CGSize(width: 4 * frame.width, height: frame.height)
        backgroundImage.zPosition = -1
        scene?.addChild(backgroundImage)
    }
    
    private func setupPhysicsWorld() {
        guard let scene = scene else { return }
        
        scene.physicsWorld.gravity = GC.GRAVITY
        scene.physicsWorld.contactDelegate = scene
    }

    private func setupCamera() {
        guard let scene = scene else { return }
        scene.cameraManager = CameraManager(frame: frame, minimumHeight: frame.midY * 1.05)
        scene.camera = scene.cameraManager.cameraNode
        scene.camera?.position = CGPoint(x: -frame.midX, y: -frame.midY)
        scene.addChild(scene.cameraManager.cameraNode)

        let background = SKSpriteNode(imageNamed: "background_gradient")
        background.size = frame.size
        background.position = CGPoint(x: frame.minX, y: frame.minY)
        background.zPosition = -2
        
        scene.cameraManager.cameraNode.addChild(background)
    }

    func animateCameraIntro() {
        guard let scene = scene else { return }
        
        let startingPosition = CGPoint(x: frame.midX, y: scene.cameraManager.cameraNode.position.y + frame.height * 10)
        
        scene.cameraManager.cameraNode.position = startingPosition
        scene.cameraManager.cameraNode.setScale(3)
        
        let finalPosition = CGPoint(x: frame.midX, y: scene.catEntity.spriteComponent.node.position.y + frame.height * 0.1)
        
        let moveAction = SKAction.move(to: finalPosition, duration: 3.0)
        moveAction.timingMode = .easeInEaseOut

        let scaleAction = SKAction.scale(to: 1, duration: 3.0)
        scaleAction.timingMode = .easeInEaseOut
        
        scene.cameraManager.cameraNode.run(.group([scaleAction, moveAction])) {
            scene.canStart = true
        }
    }
    
    private func setupEntities() {
        guard let scene = scene else { return }
        
        setupCatEntity()
        setupCucumberEntity()
        
        scene.wallFactory = WallFactory(frame: frame, cameraPositionY: scene.cameraManager.cameraNode.position.y, firstWallsHeight: frame.height/2)
    }

    private func setupCatEntity() {
        guard let scene = scene else { return }
        let t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
        scene.catEntity = CatEntity(size: CGSize(width: 76, height: 109).applying(t))
        guard let catNode = scene.catEntity.component(ofType: CatSpriteComponent.self)?.node else { return }
        catNode.position = CGPoint(x: frame.midX, y: frame.midY)
        catNode.zPosition = 2
        scene.addChild(catNode)
        scene.catEntity.prepareForJump(hasStarted: false)
        scene.startingHeight = scene.catEntity.spriteComponent.node.position.y
        scene.catEntity.agentComponent.setPosition(scene.catEntity.spriteComponent.node.position)
    }

    private func setupCucumberEntity() {
        guard let scene = scene else { return }
        let t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
        scene.cucumberEntity = CucumberEntity(size: CGSize(width: 62, height: 84).applying(t))
        guard let cucumberNode = scene.cucumberEntity.component(ofType: CucumberSpriteComponent.self)?.node else { return }
        cucumberNode.position = CGPoint(x: frame.midX, y: frame.midY / 2.5)
        cucumberNode.zPosition = 5
        cucumberNode.isHidden = true
        scene.cucumberEntity.agentComponent.setPosition(scene.cucumberEntity.spriteComponent.node.position)
        
        scene.addChild(cucumberNode)
    }

    private func setupHUD() {
        guard let scene = scene else { return }
        scene.hud = HUDNode()
        scene.hud.setup(withFrame: frame)
        scene.cameraManager.cameraNode.addChild(scene.hud)
        
        scene.pauseScreen = PauseScreen()
        scene.pauseScreen.setup(withFrame: frame)
        scene.pauseScreen.isHidden = true
        scene.cameraManager.cameraNode.addChild(scene.pauseScreen)
        
        scene.gameOverScreen = GameOverScreen()
        scene.gameOverScreen.setup(withFrame: frame)
        scene.gameOverScreen.isHidden = true
        scene.cameraManager.cameraNode.addChild(scene.gameOverScreen)
    }
}

//
//  HUDNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 04/04/24.
//

import SpriteKit

class HUDNode: SKSpriteNode {

    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var pauseButton: PauseButtonNode!
    var currentScoreLabel: SKLabelNode!
    var personalBestLabel: SKLabelNode!
    var crownSprite: SKSpriteNode!
    var nigiriCountLabel: SKLabelNode!
    var nigiriSprite: SKSpriteNode!
    
    weak var catnipTimerWorkItem: DispatchWorkItem?
    
    func setup(withFrame frame: CGRect) {
        self.name = GC.HUD.HUD_NAME
        
        if isIPad {
            setupForIPad(withFrame: frame)
        } else {
            setupForIphone(withFrame: frame)
        }
    }
    
    func updateCurrentScore(_ score: Int) {
        currentScoreLabel.text = "\(score) m"
    }
    
    func updateNigiriScore(_ score: Int) {
        let str = score < 10 ? "0\(score)" : "\(score)"
        
        nigiriCountLabel.text = str
    }
    
    func handleCatnipPickup() {
        catnipTimerWorkItem?.cancel()
        
        currentScoreLabel.fontColor = .catnipGreen
        
        let workItem = DispatchWorkItem {
            self.currentScoreLabel.fontColor = .white
        }
        
        catnipTimerWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }
}

extension HUDNode {
    private func setupForIphone(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
        
        let leftMargin = -frame.midX * 0.9
        let topMargin = frame.midY * 0.85
        let rightMargin = frame.midX * 0.9
        let verticalSpacing: CGFloat = 45
        
        pauseButton = PauseButtonNode(imageNamed: "pauseButton", size: CGSize(width: 56, height: 46).applying(t))
        pauseButton.zPosition = 101
        pauseButton.constraints = [
            .positionX(SKRange(constantValue: leftMargin + pauseButton.size.width/2)),
            .positionY(SKRange(constantValue: topMargin - pauseButton.size.height/2))
        ]
        
        
        addChild(pauseButton)
        
        currentScoreLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        currentScoreLabel.fontSize = 36
        currentScoreLabel.fontColor = .white
        currentScoreLabel.horizontalAlignmentMode = .right
        currentScoreLabel.verticalAlignmentMode = .top
        currentScoreLabel.text = "0 m"
        currentScoreLabel.zPosition = 100
        
        currentScoreLabel.constraints = [
            .positionX(SKRange(constantValue: rightMargin)),
            .positionY(SKRange(constantValue: topMargin - currentScoreLabel.frame.height/2))
        ]
        
        addChild(currentScoreLabel)
        
        personalBestLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        personalBestLabel.fontSize = 15
        personalBestLabel.fontColor = .white
        personalBestLabel.horizontalAlignmentMode = .right
        personalBestLabel.verticalAlignmentMode = .top
        personalBestLabel.text = "\(GameManager.shared.personalBestScore) m"
        personalBestLabel.zPosition = 100
        
        personalBestLabel.constraints = [
            .positionX(SKRange(constantValue: rightMargin)),
            .positionY(SKRange(constantValue: topMargin - verticalSpacing - personalBestLabel.frame.height/2)),
        ]
        
        addChild(personalBestLabel)
        
        let crownTexture = SKTexture(imageNamed: "crown.fill")
        crownSprite = SKSpriteNode(texture: crownTexture, size: CGSize(width: 13, height: 13).applying(t))
        crownSprite.zPosition = 100
        
        crownSprite.constraints = [
            .positionX(SKRange(constantValue: rightMargin - personalBestLabel.frame.width - crownSprite.size.width)),
            .positionY(SKRange(constantValue: topMargin - verticalSpacing - personalBestLabel.frame.height/2 - crownSprite.size.height/2 ))
        ]
            
        addChild(crownSprite)
        
        
        nigiriCountLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        nigiriCountLabel.fontSize = 32
        nigiriCountLabel.fontColor = .white
        nigiriCountLabel.text = "00"
        nigiriCountLabel.horizontalAlignmentMode = .right
        nigiriCountLabel.zPosition = 100
        
        nigiriCountLabel.constraints = [
            .positionX(SKRange(constantValue: rightMargin)),
            .positionY(SKRange(constantValue: topMargin - 2.5 * verticalSpacing))
        ]
        
        addChild(nigiriCountLabel)
        
        nigiriSprite = SKSpriteNode(imageNamed: "nigiri_score")
        nigiriSprite.size = CGSize(width: 56, height: 38).applying(t)
        nigiriSprite.zPosition = 100
        
        nigiriSprite.constraints = [
            .positionX(SKRange(constantValue: rightMargin - nigiriCountLabel.frame.width - nigiriSprite.size.width/2)),
            .positionY(SKRange(constantValue: topMargin - 2.25 * verticalSpacing))
        ]
        
        
        addChild(nigiriSprite)
    }
    
    private func setupForIPad(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 1024, y: frame.height / 1366)
        pauseButton = PauseButtonNode(imageNamed: "pauseButton", size: CGSize(width: 56*2, height: 46*2).applying(t))
        pauseButton.position = CGPoint(x: -frame.midX * 0.9, y: frame.midY * 0.9).applying(t)
        pauseButton.zPosition = 100
        pauseButton.name = "pauseButton"
        addChild(pauseButton)
        
        currentScoreLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        currentScoreLabel.fontSize = 72
        currentScoreLabel.fontColor = .white
        currentScoreLabel.horizontalAlignmentMode = .right
        currentScoreLabel.verticalAlignmentMode = .top
        currentScoreLabel.position = CGPoint(x: frame.midX, y: pauseButton.position.y * 1.2).applying(t)
        currentScoreLabel.text = "0 m"
        currentScoreLabel.zPosition = 100
        addChild(currentScoreLabel)
        
        personalBestLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        personalBestLabel.fontSize = 30
        personalBestLabel.fontColor = .white
        personalBestLabel.horizontalAlignmentMode = .right
        personalBestLabel.verticalAlignmentMode = .top
        personalBestLabel.text = "\(GameManager.shared.personalBestScore) m"
        personalBestLabel.zPosition = 100
        personalBestLabel.position = CGPoint(x: currentScoreLabel.position.x * 1.2, y: frame.midY * 0.78).applying(t)
        
        let crownTexture = SKTexture(imageNamed: "crown.fill")
        crownSprite = SKSpriteNode(texture: crownTexture, size: CGSize(width: 26, height: 26).applying(t))
        crownSprite.zPosition = 100
        crownSprite.position = CGPoint(x: personalBestLabel.frame.minX - crownSprite.frame.width/2, y: frame.midY * 0.75).applying(t)
        
        addChild(personalBestLabel)
        addChild(crownSprite)
        
        
        nigiriCountLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        nigiriCountLabel.fontSize = 32
        nigiriCountLabel.fontColor = .white
        nigiriCountLabel.text = "00"
        nigiriCountLabel.position = CGPoint(x: personalBestLabel.position.x * 0.95, y: personalBestLabel.position.y * 0.81)
        nigiriCountLabel.zPosition = 100
        addChild(nigiriCountLabel)
        
        nigiriSprite = SKSpriteNode(imageNamed: "nigiri_score")
        nigiriSprite.size = CGSize(width: 56, height: 38).applying(t)
        nigiriSprite.position = CGPoint(x: nigiriCountLabel.frame.minX - nigiriSprite.frame.width/2, y: nigiriCountLabel.position.y * 1.18).applying(t)
        nigiriSprite.zPosition = 100
        addChild(nigiriSprite)
    }
}

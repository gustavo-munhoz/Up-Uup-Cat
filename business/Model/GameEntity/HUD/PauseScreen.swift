//
//  PauseNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 05/04/24.
//

import SpriteKit

class PauseScreen: SKSpriteNode {
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var gameLabel: SKLabelNode!
    var pausedLabel: SKLabelNode!
    var scoreTitleLabel: SKLabelNode!
    var currentScoreLabel: SKLabelNode!
    var bestScoreTitleLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    
    var backgroundImage: SKSpriteNode!
    var continueButton: ContinueButtonNode!
    var homeButton: HomeButtonNode!
    
    func setup(withFrame frame: CGRect) {
        setupBackground(frame: frame)
        
        if isIPad {
            setupForIPad(withFrame: frame)
        } else {
            setupForIphone(withFrame: frame)
        }
    }
    
    func update(withScore score: Int) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 1.5, height: 1.5)
        shadow.shadowBlurRadius = 5
        
        currentScoreLabel.attributedText = NSMutableAttributedString(string: "\(score) m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Black", size: 64)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.shadow: shadow
        ])
    }
    
    private func setupBackground(frame: CGRect) {
        backgroundImage = SKSpriteNode(texture: SKTexture(imageNamed: "background_paused"), size: frame.size)
        backgroundImage.zPosition = 101
        addChild(backgroundImage)
    }
    
}

extension PauseScreen {
    func setupForIphone(withFrame frame: CGRect) {
        let centerX: CGFloat = 0
        var topMargin = frame.midY * 0.75
        let verticalSpacing: CGFloat = frame.size.height < 700 ? 60 : 80

        var bottomMargin = -frame.midY * 0.9
        
        setupContentsForIphone()

        addChild(gameLabel)
        gameLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (gameLabel.frame.height + verticalSpacing/4)

        addChild(pausedLabel)
        pausedLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (pausedLabel.frame.height + verticalSpacing/3)

        addChild(scoreTitleLabel)
        scoreTitleLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (scoreTitleLabel.frame.height + verticalSpacing)

        addChild(currentScoreLabel)
        currentScoreLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (currentScoreLabel.frame.height + verticalSpacing/4)

        addChild(bestScoreTitleLabel)
        bestScoreTitleLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (bestScoreTitleLabel.frame.height + verticalSpacing/2)

        addChild(bestScoreLabel)
        bestScoreLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]

        topMargin -= (bestScoreLabel.frame.height + verticalSpacing/2)

        homeButton.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: bottomMargin))
        ]
        addChild(homeButton)
        
        bottomMargin += (continueButton.size.height/1.25)
        
        addChild(continueButton)
        continueButton.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: bottomMargin))
        ]
    }

    private func setupContentsForIphone() {
        gameLabel = SKLabelNode(fontNamed: "Urbanist-ExtraBold")
        gameLabel.fontSize = 54
        gameLabel.fontColor = .white
        gameLabel.text = "Game"
        gameLabel.zPosition = 101

        pausedLabel = SKLabelNode(fontNamed: "Urbanist-ExtraBold")
        pausedLabel.fontSize = 54
        pausedLabel.fontColor = .white
        pausedLabel.text = "Paused"
        pausedLabel.zPosition = 101

        scoreTitleLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        scoreTitleLabel.fontSize = 32
        scoreTitleLabel.fontColor = .white
        scoreTitleLabel.text = "Score"
        scoreTitleLabel.zPosition = 101

        currentScoreLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        currentScoreLabel.fontSize = 64
        currentScoreLabel.fontColor = .white
        currentScoreLabel.text = "0 m"
        currentScoreLabel.zPosition = 102

        bestScoreTitleLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        bestScoreTitleLabel.fontSize = 16
        bestScoreTitleLabel.fontColor = .white
        bestScoreTitleLabel.text = "Your Best"
        bestScoreTitleLabel.zPosition = 101

        bestScoreLabel = SKLabelNode(fontNamed: "Urbanist-Bold")
        bestScoreLabel.fontSize = 32
        bestScoreLabel.fontColor = .white
        bestScoreLabel.text = "\(GameManager.shared.personalBestScore) m"
        bestScoreLabel.zPosition = 101

        continueButton = ContinueButtonNode(size: CGSize(width: 353, height: 63))
        continueButton.zPosition = 101
        
        homeButton = HomeButtonNode(size: CGSize(width: 85, height: 24))
        homeButton.zPosition = 101
    }
    
    private func setupForIPad(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 1024, y: frame.height / 1366)
        
        gameLabel = SKLabelNode(attributedText: NSAttributedString(string: "game", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        pausedLabel = SKLabelNode(attributedText: NSAttributedString(string: "paused", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        scoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "score", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 64)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        bestScoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "your best", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 32)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        bestScoreLabel = SKLabelNode(attributedText: NSAttributedString(string: "\(GameManager.shared.personalBestScore) m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 64)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        gameLabel.position = CGPoint(x: 0, y: frame.midY * 0.8).applying(t)
        gameLabel.zPosition = 101
        addChild(gameLabel)
        
        pausedLabel.position = CGPoint(x: 0, y: gameLabel.position.y * 0.85).applying(t)
        pausedLabel.zPosition = 101
        addChild(pausedLabel)
        
        scoreTitleLabel.position = CGPoint(x: 0, y: pausedLabel.position.y * 0.7).applying(t)
        scoreTitleLabel.zPosition = 101
        addChild(scoreTitleLabel)
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 1.5, height: 1.5)
        shadow.shadowBlurRadius = 5
        
        currentScoreLabel = SKLabelNode(attributedText: NSMutableAttributedString(string: "0 m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Black", size: 64)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.shadow: shadow
        ]))
        
        currentScoreLabel.position = CGPoint(x: 0, y: scoreTitleLabel.position.y * 0.7).applying(t)
        currentScoreLabel.zPosition = 102
        addChild(currentScoreLabel)
        
        bestScoreTitleLabel.position = CGPoint(x: 0, y: currentScoreLabel.position.y * 0.3).applying(t)
        bestScoreTitleLabel.zPosition = 101
        addChild(bestScoreTitleLabel)
        
        bestScoreLabel.position = CGPoint(x: 0, y: -bestScoreTitleLabel.position.y * 1.5).applying(t)
        bestScoreLabel.zPosition = 101
        addChild(bestScoreLabel)
        
        continueButton = ContinueButtonNode(size: CGSize(width: 353*2, height: 63*2).applying(t))
        continueButton.position = CGPoint(x: 0, y: -frame.midY * 0.9).applying(t)
        continueButton.zPosition = 101
        addChild(continueButton)
    }
}

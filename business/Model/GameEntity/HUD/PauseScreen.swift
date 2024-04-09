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

class ContinueButtonNode: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "continueButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PauseScreen {
    private func setupForIphone(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
        
        gameLabel = SKLabelNode(attributedText: NSAttributedString(string: "game", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 54)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        pausedLabel = SKLabelNode(attributedText: NSAttributedString(string: "paused", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 54)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        scoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "score", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 32)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        bestScoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "your best", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        bestScoreLabel = SKLabelNode(attributedText: NSAttributedString(string: "\(GameManager.shared.personalBestScore) m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        gameLabel.position = CGPoint(x: 0, y: frame.midY * 0.6).applying(t)
        gameLabel.zPosition = 101
        addChild(gameLabel)
        
        pausedLabel.position = CGPoint(x: 0, y: gameLabel.position.y * 0.75).applying(t)
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
        
        currentScoreLabel.position = CGPoint(x: 0, y: scoreTitleLabel.position.y * 0.5).applying(t)
        currentScoreLabel.zPosition = 102
        addChild(currentScoreLabel)
        
        bestScoreTitleLabel.position = CGPoint(x: 0, y: currentScoreLabel.position.y * 0.3).applying(t)
        bestScoreTitleLabel.zPosition = 101
        addChild(bestScoreTitleLabel)
        
        bestScoreLabel.position = CGPoint(x: 0, y: -bestScoreTitleLabel.position.y).applying(t)
        bestScoreLabel.zPosition = 101
        addChild(bestScoreLabel)
        
        continueButton = ContinueButtonNode(size: CGSize(width: 353, height: 63).applying(t))
        continueButton.position = CGPoint(x: 0, y: -frame.midY * 0.8).applying(t)
        continueButton.zPosition = 101
        addChild(continueButton)
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

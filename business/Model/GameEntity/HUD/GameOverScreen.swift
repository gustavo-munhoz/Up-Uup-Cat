//
//  GameOverScreen.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 05/04/24.
//

import SpriteKit

class GameOverScreen: SKSpriteNode {
    var gameLabel: SKLabelNode!
    var overLabel: SKLabelNode!
    var scoreTitleLabel: SKLabelNode!
    var currentScoreLabel: SKLabelNode!
    var bestScoreTitleLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    
    var backgroundImage: SKSpriteNode!
    var restartButton: RestartButtonNode!
    
    func setup(withFrame frame: CGRect) {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        setupBackground(frame: frame)
        
        if isIPad {
            setupForIPad(withFrame: frame)
        } else {
            setupForIphone(withFrame: frame)
        }
    }
    
    private func setupBackground(frame: CGRect) {
        backgroundImage = SKSpriteNode(texture: SKTexture(imageNamed: "background_over"), size: frame.size)
        backgroundImage.zPosition = 101
        addChild(backgroundImage)
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
    
}

class RestartButtonNode: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "restartButton"), color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameOverScreen {
    private func setupForIphone(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 393, y: frame.height / 852)
        
        gameLabel = SKLabelNode(attributedText: NSAttributedString(string: "game", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 54)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        overLabel = SKLabelNode(attributedText: NSAttributedString(string: "over", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 54)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        scoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "score", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 36)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        currentScoreLabel = SKLabelNode(attributedText: NSMutableAttributedString(string: "0 m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Black", size: 96)!,
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
        
        gameLabel.position = CGPoint(x: 0, y: frame.midY * 0.45).applying(t)
        gameLabel.zPosition = 101
        addChild(gameLabel)
        
        overLabel.position = CGPoint(x: 0, y: gameLabel.position.y * 0.7).applying(t)
        overLabel.zPosition = 101
        addChild(overLabel)
        
        scoreTitleLabel.position = CGPoint(x: 0, y: overLabel.position.y * 0.25).applying(t)
        scoreTitleLabel.zPosition = 101
        addChild(scoreTitleLabel)
        
        currentScoreLabel.position = CGPoint(x: 0, y: -scoreTitleLabel.position.y).applying(t)
        currentScoreLabel.zPosition = 102
        addChild(currentScoreLabel)
        
        bestScoreTitleLabel.position = CGPoint(x: 0, y: currentScoreLabel.position.y * 3.15).applying(t)
        bestScoreTitleLabel.zPosition = 101
        addChild(bestScoreTitleLabel)
        
        bestScoreLabel.position = CGPoint(x: 0, y: bestScoreTitleLabel.position.y * 1.35).applying(t)
        bestScoreLabel.zPosition = 101
        addChild(bestScoreLabel)
        
        restartButton = RestartButtonNode(size: CGSize(width: 353, height: 63).applying(t))
        restartButton.position = CGPoint(x: 0, y: -frame.midY * 0.8).applying(t)
        restartButton.zPosition = 101
        addChild(restartButton)
    }
    
    private func setupForIPad(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 1024, y: frame.height / 1366)
        
        gameLabel = SKLabelNode(attributedText: NSAttributedString(string: "game", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        overLabel = SKLabelNode(attributedText: NSAttributedString(string: "over", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        scoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(string: "score", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 72)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        currentScoreLabel = SKLabelNode(attributedText: NSMutableAttributedString(string: "0 m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Black", size: 192)!,
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
        
        gameLabel.position = CGPoint(x: 0, y: frame.midY * 0.45).applying(t)
        gameLabel.zPosition = 101
        addChild(gameLabel)
        
        overLabel.position = CGPoint(x: 0, y: gameLabel.position.y * 0.7).applying(t)
        overLabel.zPosition = 101
        addChild(overLabel)
        
        scoreTitleLabel.position = CGPoint(x: 0, y: overLabel.position.y * 0.25).applying(t)
        scoreTitleLabel.zPosition = 101
        addChild(scoreTitleLabel)
        
        currentScoreLabel.position = CGPoint(x: 0, y: -scoreTitleLabel.position.y * 0.9).applying(t)
        currentScoreLabel.zPosition = 102
        addChild(currentScoreLabel)
        
        bestScoreTitleLabel.position = CGPoint(x: 0, y: currentScoreLabel.position.y * 6).applying(t)
        bestScoreTitleLabel.zPosition = 101
        addChild(bestScoreTitleLabel)
        
        bestScoreLabel.position = CGPoint(x: 0, y: bestScoreTitleLabel.position.y * 2).applying(t)
        bestScoreLabel.zPosition = 101
        addChild(bestScoreLabel)
        
        restartButton = RestartButtonNode(size: CGSize(width: 353*2, height: 63*2).applying(t))
        restartButton.position = CGPoint(x: 0, y: -frame.midY * 0.8).applying(t)
        restartButton.zPosition = 101
        addChild(restartButton)
    }
}

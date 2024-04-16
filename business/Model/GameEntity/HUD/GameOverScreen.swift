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
    var nigiriBalanceTitleLabel: SKLabelNode!
    var nigiriBalanceLabel: SKLabelNode!
     
    var backgroundImage: SKSpriteNode!
    
    var nigiriBalanceImage: SKSpriteNode!
    var watchAdButton: WatchAdButtonNode!
    var restartButton: RestartButtonNode!
    var backgroundStar: SKSpriteNode!
    
    var homeButton: HomeButtonNode!
    
    var isHighScore = false
    
    func setup(withFrame frame: CGRect, isHighScore: Bool = false) {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        self.isHighScore = isHighScore
        setupBackground(frame: frame)
        
        if isIPad {
            setupForIPad(withFrame: frame)
        } else {
            setupForIphone(withFrame: frame)
        }
    }
    
    private func setupBackground(frame: CGRect) {
        let bg = isHighScore ? "background_over_highscore" : "background_over"
        backgroundImage = SKSpriteNode(texture: SKTexture(imageNamed: bg), size: frame.size)
        backgroundImage.zPosition = 101
        addChild(backgroundImage)
        
        if isHighScore {
            backgroundStar = SKSpriteNode(texture: SKTexture(imageNamed: "background_star"), size: CGSize(widthAndHeight: 564))
            
            backgroundStar.position = CGPoint(x: 0, y: 0)
            backgroundImage.addChild(backgroundStar)
            
            backgroundStar.run(SKAction.repeatForever(.rotate(byAngle: -.pi/2, duration: 10)))
        }
    }
    
    func update(withScore score: Int) {
        currentScoreLabel.text = "\(score) m"
    }
    
}

extension GameOverScreen {
    private func setupContentsForIphone() {
        gameLabel = SKLabelNode(fontNamed: "Urbanist-ExtraBold")
        gameLabel.fontSize = 54
        gameLabel.fontColor = .white
        gameLabel.text = isHighScore ? "congrats!" : "Game"
        gameLabel.zPosition = 101

        overLabel = SKLabelNode(fontNamed: "Urbanist-ExtraBold")
        overLabel.fontSize = 54
        overLabel.fontColor = .white
        overLabel.text = "Over"
        overLabel.zPosition = 101

        scoreTitleLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        scoreTitleLabel.fontSize = 36
        scoreTitleLabel.fontColor = .white
        scoreTitleLabel.text = isHighScore ? "New high score!" : "Score"
        scoreTitleLabel.zPosition = 101

        currentScoreLabel = SKLabelNode(fontNamed: "Urbanist-Black")
        currentScoreLabel.fontSize = 96
        currentScoreLabel.fontColor = .white
        currentScoreLabel.text = "\(GameManager.shared.currentScore.value) m"
        currentScoreLabel.zPosition = 101

        bestScoreTitleLabel = SKLabelNode(fontNamed: "Urbanist-Medium")
        bestScoreTitleLabel.fontSize = 16
        bestScoreTitleLabel.fontColor = .white
        bestScoreTitleLabel.text = isHighScore ? "Your previous best" : "Your best"
        bestScoreTitleLabel.zPosition = 101

        bestScoreLabel = SKLabelNode(fontNamed: "Urbanist-Bold")
        bestScoreLabel.fontSize = 32
        bestScoreLabel.fontColor = .white
        bestScoreLabel.text = "\(GameManager.shared.personalBestScore) m"
        bestScoreLabel.zPosition = 101
        
        nigiriBalanceTitleLabel = SKLabelNode(fontNamed: "Urbanist-Semibold")
        nigiriBalanceTitleLabel.fontSize = 16
        nigiriBalanceTitleLabel.fontColor = .white
        nigiriBalanceTitleLabel.text = "Nigiris"
        nigiriBalanceTitleLabel.zPosition = 101
        
        nigiriBalanceLabel = SKLabelNode(fontNamed: "Urbanist-Bold")
        nigiriBalanceLabel.fontSize = 32
        nigiriBalanceLabel.fontColor = .white
        nigiriBalanceLabel.text = "\(GameManager.shared.currentNigiriScore.value)"
        nigiriBalanceLabel.zPosition = 101
        
        nigiriBalanceImage = SKSpriteNode(imageNamed: "nigiri_score")
        nigiriBalanceImage.size = CGSize(width: 71, height: 43)
        nigiriBalanceImage.zPosition = 101
        
        watchAdButton = WatchAdButtonNode(size: CGSize(width: 368, height: 110), isHighScore: isHighScore)
        watchAdButton.zPosition = 101
        
        restartButton = RestartButtonNode(size: CGSize(width: 353, height: 63))
        restartButton.zPosition = 101
        
        homeButton = HomeButtonNode(size: CGSize(width: 85, height: 24))
        homeButton.zPosition = 101
    }
    
    private func setupForIphone(withFrame frame: CGRect) {
        var topMargin = frame.midY * 0.75
        let centerX: CGFloat = 0
        let verticalSpacing: CGFloat = frame.size.height < 700 ? 60 : 80
        let horizontalSpacing: CGFloat = 32
        
        setupContentsForIphone()
        
        gameLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        addChild(gameLabel)
        
        topMargin -= (gameLabel.frame.height + verticalSpacing/4)
        
        overLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        
        if !isHighScore { addChild(overLabel) }
        
        topMargin -= (overLabel.frame.height + verticalSpacing/3)
        
        scoreTitleLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(scoreTitleLabel)
        
        topMargin -= (scoreTitleLabel.frame.height + verticalSpacing)
        
        currentScoreLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(currentScoreLabel)
        
        topMargin -= (currentScoreLabel.frame.height/2)
        
        if isHighScore {
            currentScoreLabel.run(.repeatForever(
                .sequence([
                    .scale(to: 0.9, duration: 0.75),
                    .scale(to: 1.1, duration: 0.75)
                ])))
        }
        
        bestScoreTitleLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(bestScoreTitleLabel)
        
        topMargin -= (bestScoreTitleLabel.frame.height + verticalSpacing/4)
        
        bestScoreLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(bestScoreLabel)
        
        topMargin -= (bestScoreLabel.frame.height + verticalSpacing/4)
        
        nigiriBalanceTitleLabel.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(nigiriBalanceTitleLabel)
        
        topMargin -= (nigiriBalanceTitleLabel.frame.height + verticalSpacing/2)
        
        nigiriBalanceImage.constraints = [
            .positionX(SKRange(constantValue: centerX + horizontalSpacing)),
            .positionY(SKRange(constantValue: topMargin + nigiriBalanceLabel.frame.height/2))
        ]
        
        nigiriBalanceLabel.constraints = [
            .positionX(SKRange(constantValue: centerX - horizontalSpacing)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(nigiriBalanceImage)
        addChild(nigiriBalanceLabel)
        
        topMargin -= (nigiriBalanceImage.frame.height + verticalSpacing/4)
        
        watchAdButton.constraints = [
            .positionX(SKRange(constantValue: centerX + 8)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(watchAdButton)
        
        topMargin -= (watchAdButton.size.height/1.25)
        
        restartButton.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(restartButton)
        
        topMargin -= (restartButton.size.height)
        
        homeButton.constraints = [
            .positionX(SKRange(constantValue: centerX)),
            .positionY(SKRange(constantValue: topMargin))
        ]
        
        addChild(homeButton)
    }
    
    private func setupForIPad(withFrame frame: CGRect) {
        let t: CGAffineTransform = .init(scaleX: frame.width / 1024, y: frame.height / 1366)
        
        gameLabel = SKLabelNode(attributedText: NSAttributedString(
            string: isHighScore ? "Congrats!" : "Game",
            attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        overLabel = SKLabelNode(attributedText: NSAttributedString(
            string: "Over",
            attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-ExtraBold", size: 108)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]))
        
        scoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(
            string: isHighScore ? "New High Score!" : "Score",
            attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Medium", size: 72)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        currentScoreLabel = SKLabelNode(attributedText: NSMutableAttributedString(string: "\(GameManager.shared.currentScore.value) m", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Urbanist-Black", size: 192)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        bestScoreTitleLabel = SKLabelNode(attributedText: NSAttributedString(
            string: isHighScore ? "Your Previous Best" : "Your Best",
            attributes: [
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
        
        if !isHighScore {
            overLabel.position = CGPoint(x: 0, y: gameLabel.position.y * 0.7).applying(t)
            overLabel.zPosition = 101
            addChild(overLabel)
        }
        
        scoreTitleLabel.position = CGPoint(x: 0, y: overLabel.position.y * 0.35).applying(t)
        scoreTitleLabel.zPosition = 101
        addChild(scoreTitleLabel)
        
        currentScoreLabel.position = CGPoint(x: 0, y: -scoreTitleLabel.position.y).applying(t)
        currentScoreLabel.zPosition = 102
        addChild(currentScoreLabel)
        
        if isHighScore {
            currentScoreLabel.run(.repeatForever(
                .sequence([
                    .scale(to: 0.9, duration: 0.75),
                    .scale(to: 1.1, duration: 0.75)
                ])))
        }
        
        bestScoreTitleLabel.position = CGPoint(x: 0, y: currentScoreLabel.position.y * 3.15).applying(t)
        bestScoreTitleLabel.zPosition = 101
        addChild(bestScoreTitleLabel)
        
        bestScoreLabel.position = CGPoint(x: 0, y: bestScoreTitleLabel.position.y * 1.35).applying(t)
        bestScoreLabel.zPosition = 101
        addChild(bestScoreLabel)
        
        restartButton = RestartButtonNode(size: CGSize(width: 353 * 2, height: 63 * 2).applying(t))
        restartButton.position = CGPoint(x: 0, y: -frame.midY * 0.8).applying(t)
        restartButton.zPosition = 101
        addChild(restartButton)
    }
}

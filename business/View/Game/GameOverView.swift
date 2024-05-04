//
//  GameOverView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 26/04/24.
//

import UIKit
import Combine

class GameOverView: UIView {
    private var cancellables = Set<AnyCancellable>()
    
    private let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    private let scaleFactor: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1

    let isHighscore: Bool
    
    // MARK: - Labels
    
    private(set) lazy var bg: UIImageView = {
        let view = UIImageView(
            image: UIImage(
                named: "background_over\(isHighscore ? "_highscore" : "")"
            )
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if isHighscore {
            let star = UIImageView(image: UIImage(named: "background_star"))
            star.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(star)
            
            NSLayoutConstraint.activate([
                star.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                star.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                star.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.2),
                star.heightAnchor.constraint(equalTo: star.heightAnchor)
            ])
        }
        
        return view
    }()
    
    private(set) lazy var gameOverLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-ExtraBold", size: 54 * scaleFactor)
        view.text = isHighscore ? String(localized: "game_over_title_highscore") : String(localized: "game_over_title_default")
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 2
        
        return view
    }()
    
    private(set) lazy var scoreTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Medium", size: 32 * scaleFactor)
        view.text = isHighscore ? String(localized: "game_over_score_highscore") : String(localized: "game_over_score_default")
        
        return view
    }()
    
    private(set) lazy var currentScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Black", size: 64 * scaleFactor)
        view.text = "\(GameManager.shared.currentScore.value) m"
        
        return view
    }()
    
    private(set) lazy var bestScoreTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Medium", size: 16 * scaleFactor)
        view.text = isHighscore ? String(localized: "game_over_best_highscore") : String(localized: "game_over_best_default")
        
        return view
    }()
    
    private(set) lazy var bestScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Bold", size: 32 * scaleFactor)
        view.text = "\(GameManager.shared.personalBestScore) m"
        
        return view
    }()
    
    private(set) lazy var nigiriTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.text = String(localized: "game_over_nigiris")
        view.font = UIFont(name: "Urbanist-Semibold", size: 16 * scaleFactor)
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var nigiriCountLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.text = "\(GameManager.shared.currentNigiriScore.value)"
        view.font = UIFont(name: "Urbanist-Bold", size: 32 * scaleFactor)
        view.textAlignment = .right
        
        return view
    }()
    
    private(set) lazy var nigiriImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "nigiri_score"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Buttons
    
    private(set) lazy var rewardedAdButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.rectangle.fill")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20 * scaleFactor)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "game_over_watchAd"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 28 * scaleFactor)!])
        )
        config.baseBackgroundColor = .adButtonPurple
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 0
        )
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentVerticalAlignment = .center
        view.addTarget(self, action: #selector(didTapRewardedAdButton), for: .touchUpInside)
        view.contentHorizontalAlignment = isIpad ? .center : .leading
        
        return view
    }()
    
    private(set) lazy var restartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "arrow.circlepath")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18 * scaleFactor)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "game_over_restart_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 28 * scaleFactor)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var rotatingStarContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let starImageView = UIImageView(image: UIImage(named: "ad-button-star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false

        let imageText = UIImageView(image: UIImage(named: "ad-button-nigiris"))
        imageText.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(starImageView)
        container.addSubview(imageText)

        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: container.topAnchor),
            starImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            starImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            starImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            imageText.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            imageText.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 5),
            imageText.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.9),
            imageText.widthAnchor.constraint(equalTo: container.heightAnchor, multiplier: 83/82)
        ])

        starImageView.rotate(duration: 4)

        return container
    }()
    
    private(set) lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "house.fill")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16 * scaleFactor)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        
        config.attributedTitle = AttributedString(
            String(localized: "game_over_menu"),
            attributes: AttributeContainer(
                [NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 20 * scaleFactor)!]
            )
        )
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(didTapHomeButton), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Methods
    
    @objc func didTapRewardedAdButton() {
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.requestDoubleNigiriAd()
    }

    @objc func didTapRestartButton() {
        GameManager.shared.saveStats()
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.resetGame()
    }
    
    @objc func didTapHomeButton() {
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.saveStats()
        GameManager.shared.navigateBackToMenu()
    }
    
    init(isHighscore: Bool, frame: CGRect) {
        self.isHighscore = isHighscore
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupSubscriptions()
        setupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateNigiriCountDoubled() {
        let currentValue = GameManager.shared.currentNigiriScore.value
        let targetValue = currentValue * 2
        let animationDuration = 1.0
        let steps = 100
        let valuePerStep = Double(targetValue - currentValue) / Double(steps)
        var currentStep = 0

        Timer.scheduledTimer(withTimeInterval: animationDuration / Double(steps), repeats: true) { timer in
            currentStep += 1
            let newValue = currentValue + Int(Double(currentStep) * valuePerStep)
            self.nigiriCountLabel.text = "\(newValue)"

            if currentStep == steps {
                timer.invalidate()
                GameManager.shared.currentNigiriScore.value = targetValue
            }
        }
    }

    func setupAnimations() {
        UIView.animate(
            withDuration: 0.66,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                self.rotatingStarContainer.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
        )
        
        guard isHighscore else { return }
        
        // background star = bg.subviews[0]
        self.bg.subviews[0].rotate(duration: 10)
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: [.repeat, .autoreverse]
        ) {
            self.bg.subviews[0].transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
        
        
        
    }
    
    func addSubviews() {
        addSubview(bg)
        addSubview(gameOverLabel)
        addSubview(scoreTitleLabel)
        addSubview(currentScoreLabel)
        addSubview(bestScoreTitleLabel)
        addSubview(bestScoreLabel)
        addSubview(nigiriTitleLabel)
        addSubview(nigiriCountLabel)
        addSubview(nigiriImage)
        
        addSubview(rewardedAdButton)
        addSubview(rotatingStarContainer)
        addSubview(restartButton)
        addSubview(homeButton)
    }
    
    func setupConstraints() {
        let spacing: CGFloat = frame.height < 700 ? 10 : 60
        
        NSLayoutConstraint.activate([
            bg.trailingAnchor.constraint(equalTo: trailingAnchor),
            bg.leadingAnchor.constraint(equalTo: leadingAnchor),
            bg.topAnchor.constraint(equalTo: topAnchor),
            bg.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            gameOverLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: isHighscore ? 0.8 : 0.5),
            gameOverLabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height * 0.05),
            gameOverLabel.heightAnchor.constraint(equalToConstant: 140 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            scoreTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreTitleLabel.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: spacing/4),
            scoreTitleLabel.heightAnchor.constraint(equalToConstant: 40 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            currentScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentScoreLabel.topAnchor.constraint(equalTo: scoreTitleLabel.bottomAnchor, constant: spacing/4),
            currentScoreLabel.heightAnchor.constraint(equalToConstant: 80 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            bestScoreTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bestScoreTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestScoreTitleLabel.topAnchor.constraint(equalTo: currentScoreLabel.bottomAnchor, constant: spacing/4),
            bestScoreTitleLabel.heightAnchor.constraint(equalToConstant: 20 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            bestScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bestScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestScoreLabel.topAnchor.constraint(equalTo: bestScoreTitleLabel.bottomAnchor, constant: spacing/4),
            bestScoreLabel.heightAnchor.constraint(equalToConstant: 40 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            nigiriTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            nigiriTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            nigiriTitleLabel.topAnchor.constraint(equalTo: bestScoreLabel.bottomAnchor, constant: spacing/4 * scaleFactor),
            nigiriTitleLabel.heightAnchor.constraint(equalToConstant: 24 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            nigiriCountLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -25 * scaleFactor),
            nigiriCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            nigiriCountLabel.topAnchor.constraint(equalTo: nigiriTitleLabel.bottomAnchor),
            nigiriCountLabel.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            nigiriImage.leadingAnchor.constraint(equalTo: nigiriCountLabel.trailingAnchor, constant: 12),
            nigiriImage.centerYAnchor.constraint(equalTo: nigiriCountLabel.centerYAnchor),
            nigiriImage.widthAnchor.constraint(equalToConstant: 80 * scaleFactor),
            nigiriImage.heightAnchor.constraint(equalToConstant: 47 * scaleFactor),
        ])
        
        NSLayoutConstraint.activate([
            rewardedAdButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            rewardedAdButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            rewardedAdButton.topAnchor.constraint(equalTo: nigiriCountLabel.bottomAnchor, constant: spacing/4),
            rewardedAdButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            rotatingStarContainer.heightAnchor.constraint(equalTo: rewardedAdButton.heightAnchor, multiplier: 1.5),
            rotatingStarContainer.widthAnchor.constraint(equalTo: rotatingStarContainer.heightAnchor),
            rotatingStarContainer.centerXAnchor.constraint(equalTo: rewardedAdButton.trailingAnchor, constant: -20),
            rotatingStarContainer.centerYAnchor.constraint(equalTo: rewardedAdButton.centerYAnchor)
        ])
  
        
        NSLayoutConstraint.activate([
            restartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            restartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            restartButton.topAnchor.constraint(equalTo: rotatingStarContainer.bottomAnchor, constant: spacing/4),
            restartButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            homeButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: spacing/4),
            homeButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
    }
    
    func setupSubscriptions() {
        GameManager.shared.didFinishShowingRewardedAd.sink { [weak self] didFinish in
            if didFinish {
                self?.animateNigiriCountDoubled()
            }
        }
        .store(in: &cancellables)
    }
}

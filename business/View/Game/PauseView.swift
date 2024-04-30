//
//  PauseView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 26/04/24.
//

import UIKit
import Combine

class PauseView: UIView {
    private let currentScore: Int
    
    private let scaleFactor: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1

    // MARK: - Labels
    
    private(set) lazy var bg: UIImageView = {
        let view = UIImageView(image: UIImage(named: "background_paused"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private(set) lazy var gamePausedLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-ExtraBold", size: 54 * scaleFactor)
        view.text = String(localized: "pause_view_title")
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
        view.text = String(localized: "pause_view_score")
        
        return view
    }()
    
    private(set) lazy var currentScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Black", size: 64 * scaleFactor)
        view.text = "\(currentScore) m"
        
        return view
    }()
    
    private(set) lazy var bestScoreTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "Urbanist-Medium", size: 16 * scaleFactor)
        view.text = String(localized: "pause_view_best_title")
        
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
    
    // MARK: - Buttons
    
    private(set) lazy var continueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25 * scaleFactor)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "pause_view_continue_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32 * scaleFactor)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var restartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "arrow.circlepath")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25 * scaleFactor)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "pause_view_restart_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32 * scaleFactor)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "house.fill")
        config.imagePadding = 10 * scaleFactor
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16 * scaleFactor)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        
        config.attributedTitle = AttributedString(
            String(localized: "pause_view_menu_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 20 * scaleFactor)!])
        )
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(didTapHomeButton), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Methods
    
    @objc func didTapContinueButton() {
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.resumeGame()
    }

    @objc func didTapRestartButton() {
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.resetGame()
    }
    
    @objc func didTapHomeButton() {
        SoundEffect.pop.playIfAllowed()
        GameManager.shared.navigateBackToMenu()
    }
    
    init(frame: CGRect, currentScore: Int) {
        self.currentScore = currentScore
        
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(bg)
        addSubview(gamePausedLabel)
        addSubview(scoreTitleLabel)
        addSubview(currentScoreLabel)
        addSubview(bestScoreTitleLabel)
        addSubview(bestScoreLabel)
        
        addSubview(continueButton)
        addSubview(restartButton)
        addSubview(homeButton)
    }
    
    func setupConstraints() {
        let spacing: CGFloat = frame.height < 700 ? 60 : 80
        
        NSLayoutConstraint.activate([
            bg.trailingAnchor.constraint(equalTo: trailingAnchor),
            bg.leadingAnchor.constraint(equalTo: leadingAnchor),
            bg.topAnchor.constraint(equalTo: topAnchor),
            bg.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gamePausedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            gamePausedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            gamePausedLabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height * 0.05),
            gamePausedLabel.heightAnchor.constraint(equalToConstant: 140 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            scoreTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreTitleLabel.topAnchor.constraint(equalTo: gamePausedLabel.bottomAnchor, constant: spacing/2),
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
            bestScoreTitleLabel.topAnchor.constraint(equalTo: currentScoreLabel.bottomAnchor, constant: spacing/2),
            bestScoreTitleLabel.heightAnchor.constraint(equalToConstant: 20 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            bestScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bestScoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bestScoreLabel.topAnchor.constraint(equalTo: bestScoreTitleLabel.bottomAnchor, constant: spacing/4),
            bestScoreLabel.heightAnchor.constraint(equalToConstant: 40 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            continueButton.topAnchor.constraint(equalTo: bestScoreLabel.bottomAnchor, constant: spacing/4 * scaleFactor),
            continueButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            restartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            restartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            restartButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: spacing/4),
            restartButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40 * scaleFactor),
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 * scaleFactor),
            homeButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: spacing/4),
            homeButton.heightAnchor.constraint(equalToConstant: 60 * scaleFactor)
        ])
    }
}


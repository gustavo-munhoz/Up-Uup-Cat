//
//  MenuView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit
import SwiftyGif

class MenuView: UIView {
    var handlePlayTouch: () -> Void = {}
    var handleShopTouch: () -> Void = {}
    var handleRankingTouch: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BACKGROUND
    
    private(set) lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_bg"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var backgroundGradient: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bg_gradient"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var gameLogo: UIImageView = {
        let view = UIImageView(image: UIImage(named: "game_logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private(set) lazy var backgroundPaws: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_bg_paws"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var backgroundBuildings: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_bg_buildings"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Settings and tutorial
    
    private(set) lazy var tutorialButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "info.circle")
        config.attributedTitle = AttributedString(
            String(localized: "how_to_play"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 24)!])
        )
        config.imagePadding = 12
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressTutorialButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var settingsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "gearshape.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressSettingsButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var closeModalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        button.alpha = 0
        button.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        
        return button
    }()
    
    private(set) lazy var settingsView: SettingsView = {
        let view = SettingsView()
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var tutorialView: TutorialView = {
        let view = TutorialView()
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - BOTTOM BUTTONS
    
    private(set) lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 20
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "play_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var shopButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "cart.fill")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "shop_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressShopButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var rankingButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "trophy.fill")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(
            String(localized: "ranking_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!])
        )
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressRankingButton), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Gestures
    
    private func setupGestureRecognizers() {
        let tutorialSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        tutorialSwipeDown.direction = .down
        
        let settingsSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        settingsSwipeDown.direction = .down
        tutorialView.addGestureRecognizer(tutorialSwipeDown)
        tutorialView.isUserInteractionEnabled = true
        
        settingsView.addGestureRecognizer(settingsSwipeDown)
        settingsView.isUserInteractionEnabled = true
    }

    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            resetMenuVisibility()
        }
    }
    
    // MARK: - Animations
    
    @objc func closeModal() {
        resetMenuVisibility()
    }
    
    private func resetMenuVisibility() {
        UIView.animate(withDuration: 0.5, animations: {
            self.closeModalButton.alpha = 0
            
            self.tutorialView.alpha = 0
            self.tutorialView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            self.gameLogo.transform = .identity
            
            if self.settingsView.alpha == 1 {
                self.animateSettingsOut()
            }
            
        }) { _ in
            self.animateUnhideViews()
        }
    }
    
    private func animateHideViews(_ completion: @escaping () -> Void) {
        let logoScaleDown = CGAffineTransform(scaleX: 0.35, y: 0.35)
        let logoMoveUp = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height / 4)

        let viewsToHide = [settingsButton, tutorialButton, playButton, rankingButton, shopButton]
        
        UIView.animate(withDuration: 0.25, animations: {
            viewsToHide.forEach { $0.alpha = 0 }
            self.gameLogo.transform = logoScaleDown.concatenating(logoMoveUp)
            
        }) { _ in
            completion()
        }
    }
    
    private func animateUnhideViews() {
        let viewsToUnhide = [settingsButton, tutorialButton, playButton, rankingButton, shopButton]
        UIView.animate(withDuration: 0.5, animations: {
            viewsToUnhide.forEach { $0.alpha = 1 }
        })
    }
    
    private func animateTutorial() {
        animateHideViews {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.tutorialView.alpha = 1
                self.tutorialView.transform = .identity
                self.closeModalButton.alpha = 1
                
            }) { _ in
                UIView.animate(
                    withDuration: 1,
                    delay: 1,
                    options: [.beginFromCurrentState, .repeat, .autoreverse]
                ) {
                    self.tutorialView.swipeLabel.alpha = 0
                }
            }
        }
    }
    
    private func animateSettingsIn() {
        UIView.animate(
            withDuration: 1,
            delay: 1,
            options: [.beginFromCurrentState, .repeat, .autoreverse]
        ) {
            self.settingsView.swipeLabel.alpha = 0
        }
        
        animateHideViews {
            UIView.animate(withDuration: 0.5, animations: {
                self.settingsView.alpha = 1
                self.settingsView.transform = .identity
                self.closeModalButton.alpha = 1
            })
        }
    }

    private func animateSettingsOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsView.alpha = 0
            self.settingsView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        })
    }
    
    // MARK: - Button Actions
    
    @objc private func didPressTutorialButton() {
        SoundEffect.pop.playIfAllowed()
        AnalyticsService.logEventTutorialButtonPressed()
        
        animateTutorial()
    }
    
    @objc private func didPressSettingsButton() {
        SoundEffect.pop.playIfAllowed()
        animateSettingsIn()
    }
    
    @objc private func didPressPlayButton() {
        SoundEffect.pop.playIfAllowed()
        handlePlayTouch()
    }
    
    @objc private func didPressShopButton() {
        SoundEffect.pop.playIfAllowed()
        handleShopTouch()
    }
    
    @objc private func didPressRankingButton() {
        SoundEffect.pop.playIfAllowed()
        handleRankingTouch()
    }
    
    // MARK: - Setup view
    
    func addSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(backgroundPaws)
        backgroundImageView.addSubview(backgroundBuildings)
        backgroundImageView.addSubview(backgroundGradient)
        backgroundImageView.addSubview(gameLogo)
        
        addSubview(tutorialButton)
        addSubview(settingsButton)
        
        addSubview(playButton)
        addSubview(shopButton)
        addSubview(rankingButton)
        
        addSubview(tutorialView)
        addSubview(settingsView)
        addSubview(closeModalButton)
    }
    
    func setupConstraints() {
        
        setupBackgroundConstraints()
        
        NSLayoutConstraint.activate([
            tutorialButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tutorialButton.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            tutorialButton.widthAnchor.constraint(equalToConstant: 200),
            tutorialButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            settingsButton.topAnchor.constraint(equalTo: tutorialButton.topAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 43),
            settingsButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height/10),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            shopButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 25),
            shopButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            shopButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            shopButton.heightAnchor.constraint(equalTo: playButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rankingButton.topAnchor.constraint(equalTo: shopButton.bottomAnchor, constant: 25),
            rankingButton.centerXAnchor.constraint(equalTo: shopButton.centerXAnchor),
            rankingButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            rankingButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tutorialView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tutorialView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tutorialView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tutorialView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.75)
        ])
        
        NSLayoutConstraint.activate([
            settingsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            settingsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.75)
        ])
        
        NSLayoutConstraint.activate([
            closeModalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            closeModalButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            closeModalButton.widthAnchor.constraint(equalToConstant: 32),
            closeModalButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundGradient.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundGradient.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundGradient.topAnchor.constraint(equalTo: topAnchor),
            backgroundGradient.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundPaws.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundPaws.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2),
            backgroundPaws.topAnchor.constraint(equalTo: topAnchor),
            backgroundPaws.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundBuildings.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            backgroundBuildings.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor),
            backgroundBuildings.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.45),
            backgroundBuildings.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            gameLogo.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -UIScreen.main.bounds.height/10),
            gameLogo.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.9),
            gameLogo.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
    }
}

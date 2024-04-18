//
//  MenuView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit

class MenuView: UIView {
    
    var handlePlayTouch: () -> Void = {}
    var handleRankingTouch: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private(set) lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 20
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString("Play", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!]))
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var rankingButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "trophy.fill")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString("Ranking", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist-Bold", size: 32)!]))
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0.3)
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressRankingButton), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func didPressPlayButton() {
        handlePlayTouch()
    }
    
    @objc private func didPressRankingButton() {
        handleRankingTouch()
    }
    
    func addSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(backgroundPaws)
        backgroundImageView.addSubview(backgroundBuildings)
        backgroundImageView.addSubview(backgroundGradient)
        backgroundImageView.addSubview(gameLogo)
        addSubview(playButton)
        addSubview(rankingButton)
    }
    
    func setupConstraints() {
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
            gameLogo.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -UIScreen.main.bounds.height/10),
            gameLogo.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.9),
            gameLogo.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            backgroundBuildings.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            backgroundBuildings.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor),
            backgroundBuildings.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.45),
            backgroundBuildings.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height/10),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            rankingButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 25),
            rankingButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            rankingButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            rankingButton.heightAnchor.constraint(equalTo: playButton.heightAnchor)
        ])
    }
}


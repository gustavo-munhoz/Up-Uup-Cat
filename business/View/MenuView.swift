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
        let view = UIImageView(image: UIImage(named: "background_menu"))
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
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -275),
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
    
    func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(playButton)
        addSubview(rankingButton)
    }
}


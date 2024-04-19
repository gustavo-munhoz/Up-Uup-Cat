//
//  LaunchTransitionView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import UIKit

class LaunchTransitionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "launch_transition_1"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var cucumberImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "cucumber_launch"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    func addSubviews() {
        addSubview(backgroundImage)
        addSubview(cucumberImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            cucumberImage.topAnchor.constraint(equalTo: centerYAnchor, constant: -300),
            cucumberImage.leadingAnchor.constraint(equalTo: trailingAnchor),
            cucumberImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.316),
        ])
    }
    
    func startAnimation(completion: @escaping () -> Void) {
        animateCucumberEntering(completion: {
            self.animateCucumberFullyVisible(completion: {
                self.backgroundImage.image = UIImage(named: "launch_transition_2")
                SoundEffect.snore.stop()
                SoundEffect.surprise.play()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.animateCucumberDisappears {
                        self.backgroundImage.image = UIImage(named: "launch_transition_3")
                        SoundEffect.surprise.stop()
                        SoundEffect.cucumberMove.stop()
                        completion()
                    }
                }
            })
        })
    }
    
    private func animateCucumberEntering(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 2.0, animations: {
            self.cucumberImage.transform = CGAffineTransform(
                translationX: -self.cucumberImage.frame.width/2,
                y: 0)
        }, completion: { _ in
            completion()
        })
    }

    private func animateCucumberFullyVisible(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1.0,
                       delay: 2,
                       animations: {
            self.cucumberImage.transform = CGAffineTransform(
                translationX: -self.cucumberImage.frame.width,
                y: 0)
        }, completion: { _ in
            completion()
        })
    }
    
    private func animateCucumberDisappears(completion: @escaping () -> Void) {
        SoundEffect.cucumberMove.play()
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       animations: {
            self.cucumberImage.transform = .identity
        }, completion: { _ in
            completion()
        })
    }
}

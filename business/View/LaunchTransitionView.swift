//
//  LaunchTransitionView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import UIKit

class LaunchTransitionView: UIView {
    
    private let totalAnimationDuration: TimeInterval = 7.4
    private var startTime: Date!
    
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
    
    private(set) lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = UIColor.lightGray
        progress.progressTintColor = .green
        progress.progress = 0.0
        progress.layer.cornerRadius = 8
        progress.layer.borderWidth = 4
        progress.layer.borderColor = UIColor.white.cgColor
        progress.layer.masksToBounds = true
        
        return progress
    }()

    func updateProgress() {
        let progress = CGFloat(Date().timeIntervalSince(startTime)) / CGFloat(totalAnimationDuration)
        progressView.setProgress(Float(progress), animated: true)
        if progress < 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.updateProgress()
            }
        }
    }
    
    func addSubviews() {
        addSubview(backgroundImage)
        addSubview(cucumberImage)
        addSubview(progressView)
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
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            progressView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func startAnimation(completion: @escaping () -> Void) {
        startTime = Date()
        updateProgress()

        animateCucumberEntering {
            self.animateCucumberFullyVisible {
                self.backgroundImage.image = UIImage(named: "launch_transition_2")
                SoundEffect.snore.stop()
                SoundEffect.surprise.playIfAllowed()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.animateCucumberDisappears {
                        self.backgroundImage.image = UIImage(named: "launch_transition_3")
                        SoundEffect.surprise.stop()
                        SoundEffect.cucumberMove.stop()
                        completion()
                    }
                }
            }
        }
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
        SoundEffect.cucumberMove.playIfAllowed()
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       animations: {
            self.cucumberImage.transform = .identity
        }, completion: { _ in
            completion()
        })
    }
}

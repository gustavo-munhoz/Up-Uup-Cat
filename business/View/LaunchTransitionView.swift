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

    private var container: UIView!
    private var characterLabels: [UILabel] = []
    
    /// Used to animate text in a wave-like motion.
    func setupAnimatedText(text: String) {
        guard container == nil else {
            restartAnimations()
            return
        }
        
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        var lastView: UIView? = nil
        let spacing: CGFloat = 2
        let characters = Array(text)
        
        for char in characters {
            let label = UILabel()
            label.text = String(char)
            label.font = UIFont(name: "Urbanist-ExtraBold", size: 32)
            label.textColor = .menuLightPurple
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            characterLabels.append(label)

            if let lastView = lastView {
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: lastView.trailingAnchor, constant: spacing)
                ])
            } else {
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: container.leadingAnchor)
                ])
            }

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

            lastView = label
        }

        if let lastView = lastView {
            NSLayoutConstraint.activate([
                lastView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
        }
        
        restartAnimations()
    }

    func restartAnimations() {
        for (index, label) in characterLabels.enumerated() {
            animateCharacter(label, delay: TimeInterval(index) * 0.1, isLast: index == characterLabels.count - 1)
        }
    }

    func animateCharacter(_ label: UILabel, delay: TimeInterval, isLast: Bool) {
        let duration: TimeInterval = 0.2
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut], animations: {
            label.transform = CGAffineTransform(translationX: 0, y: -30).scaledBy(x: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: duration, animations: {
                label.transform = .identity
            }, completion: { _ in
                if isLast {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        self.restartAnimations()
                    }
                }
            })
        }
    }

    
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
        setupAnimatedText(text: String(localized: "loading"))

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

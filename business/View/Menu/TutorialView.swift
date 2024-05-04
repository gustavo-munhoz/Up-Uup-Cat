//
//  TutorialView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import UIKit
import SwiftyGif

class TutorialView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = UIFont(name: "Urbanist-ExtraBold", size: 40)
        view.textColor = .white
        view.text = String(localized: "how_to_play")
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var tutorialImage: UIImageView = {
        do {
            let gifManager = SwiftyGifManager(memoryLimit: 20)
            let gif = try UIImage(gifName: "tutorial-gif.gif")
            
            let view = UIImageView(gifImage: gif)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.backgroundColor = .red
            view.stopAnimatingGif()
            
            return view
            
        } catch {
            print(error.localizedDescription)
            let view = UIImageView(image: UIImage(named: "tutorial"))
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
    }()
    
    private(set) lazy var swipeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = UIFont(name: "Urbanist-Light", size: 20)
        view.text = String(localized: "swipe_down_menu")
        view.textColor = .white
        view.textAlignment = .center
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(tutorialImage)
        addSubview(swipeLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            swipeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            swipeLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            tutorialImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tutorialImage.bottomAnchor.constraint(equalTo: swipeLabel.topAnchor, constant: -12),
            tutorialImage.widthAnchor.constraint(equalTo: tutorialImage.heightAnchor, multiplier: 540/960),
            tutorialImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}


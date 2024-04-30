//
//  ItemCell.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import UIKit

class ItemCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Urbanist-ExtraBold", size: 24)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .standard
        label.numberOfLines = -1
        
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Urbanist-ExtraBold", size: 20)
        label.textColor = .catnipGreen
        label.backgroundColor = .menuPurple.withAlphaComponent(0.8)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .menuPurple.withAlphaComponent(0.1)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(priceLabel)

        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func setupGestureRecognizers() {
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(handleTouchDown(_:)))
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        addGestureRecognizer(touchDown)
    }
    
    @objc private func handleTouchDown(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
            case .began:
                animateToPressedState()
            case .ended, .cancelled:
                animateToNormalState()
            default:
                break
        }
    }
    
    private func animateToPressedState() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.5
        }
    }
    
    private func animateToNormalState() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
    }
    
    func configure(with item: ShopItem) {
        titleLabel.text = item.title
        priceLabel.text = item.price
    }
}

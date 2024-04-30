//
//  InAppPurchasesView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 28/04/24.
//

import UIKit

class InAppPurchasesView: UIView {
    
    private(set) lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "jukebox-background")?.withHorizontallyFlippedOrientation())
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var comingSoon: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = UIFont(name: "Urbanist-Bold", size: 24)
        view.textColor = .white.withAlphaComponent(0.25)
        view.text = String(localized: "iap_view_coming_soon")
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
        addSubview(backgroundImage)
        addSubview(comingSoon)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            comingSoon.trailingAnchor.constraint(equalTo: trailingAnchor),
            comingSoon.leadingAnchor.constraint(equalTo: leadingAnchor),
            comingSoon.topAnchor.constraint(equalTo: topAnchor),
            comingSoon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


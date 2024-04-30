//
//  ItemsView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 28/04/24.
//

import UIKit

class ItemsView: UIView {
    private(set) lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "jukebox-background"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.4), height: 125)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCell")
        
        return collectionView
    }()
    
    private(set) lazy var comingSoon: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = UIFont(name: "Urbanist-Bold", size: 24)
        view.textColor = .white.withAlphaComponent(0.5)
        view.text = String(localized: "items_view_coming_soon")
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
        addSubview(collectionView)
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
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.225),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            comingSoon.trailingAnchor.constraint(equalTo: trailingAnchor),
            comingSoon.leadingAnchor.constraint(equalTo: leadingAnchor),
            comingSoon.topAnchor.constraint(equalTo: topAnchor),
            comingSoon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

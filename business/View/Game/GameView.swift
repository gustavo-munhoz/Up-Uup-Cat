//
//  GameView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 03/04/24.
//

import UIKit
import SpriteKit

class GameView: UIView {
    private(set) lazy var skView: SKView = {
        let view = SKView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        addSubview(skView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            skView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skView.topAnchor.constraint(equalTo: topAnchor),
            skView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupSKScene() {
        let gameScene = GameScene(size: frame.size)
        
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
    }
}


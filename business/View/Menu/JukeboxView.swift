//
//  JukeboxView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/04/24.
//

import UIKit

class JukeboxView: UIView {
    
    private(set) lazy var bg: UIImageView = {
        let view = UIImageView(image: UIImage(named: "jukebox-background"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var titleImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "music.note"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
    
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = String(localized: "jukebox_title")
        view.textColor = .white
        view.font = UIFont(name: "Urbanist-ExtraBold", size: 40)
        
        return view
    }()
    
    private(set) lazy var titleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleImage, titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 12
        
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .singleLine
        view.separatorColor = .white
        view.showsVerticalScrollIndicator = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .menuPurple.withAlphaComponent(0.75)
        
        return view
    }()

    private(set) lazy var creditsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.attributedText =
            NSMutableAttributedString()
                .normal(String(localized: "music_credit_1"))
                .bold(String(localized: "music_credit_2"))
                .normal(String(localized: "music_credit_3"))
        
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
        addSubview(bg)
        addSubview(titleStackView)
        addSubview(tableView)
        addSubview(creditsLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bg.trailingAnchor.constraint(equalTo: trailingAnchor),
            bg.leadingAnchor.constraint(equalTo: leadingAnchor),
            bg.topAnchor.constraint(equalTo: topAnchor),
            bg.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.1),
            titleStackView.widthAnchor.constraint(equalToConstant: 200),
            titleStackView.heightAnchor.constraint(equalToConstant: 72),
        ])
        
        NSLayoutConstraint.activate([
            titleImage.heightAnchor.constraint(equalToConstant: 40),
            titleImage.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120)
        ])
        
        NSLayoutConstraint.activate([
            creditsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            creditsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            creditsLabel.widthAnchor.constraint(equalTo: widthAnchor),
            creditsLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 16 }
    var boldFont:UIFont { return UIFont(name: "Urbanist-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "Urbanist-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font: normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

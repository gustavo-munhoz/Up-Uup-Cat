//
//  MusicPaddedLabelCell.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 26/04/24.
//

import UIKit

class MusicPaddedLabelCell: UITableViewCell {
    var music: BackgroundMusic!
    let paddedLabel = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        paddedLabel.textColor = selected ? .menuYellow : .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPaddedLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPaddedLabel() {
        paddedLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(paddedLabel)
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            paddedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            paddedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            paddedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            paddedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    func configure(withTrack track: BackgroundMusic) {
        music = track
        paddedLabel.text = track.formattedName
        paddedLabel.textColor = .white
        paddedLabel.font = UIFont(name: "Urbanist-Bold", size: 20)
    }
}

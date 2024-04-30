//
//  SettingsView.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 24/04/24.
//

import UIKit

class SettingsView: UIView {
    
    var handleJukeboxButtonTouch: () -> Void = {}
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = UIFont(name: "Urbanist-ExtraBold", size: 40)
        view.textColor = .white
        view.text = String(localized: "settings_title")
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var volumeTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Urbanist", size: 20)
        view.text = String(localized: "music_volume")
        view.textColor = .white
        
        return view
    }()
    
    private(set) lazy var volumeSlider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.minimumTrackTintColor = .menuYellow
        view.maximumTrackTintColor = UIColor(white: 1, alpha: 0.5)
        view.thumbTintColor = .white
        
        view.value = UserPreferences.shared.backgroundMusicVolume
        view.maximumValue = 1
        view.minimumValue = 0
        view.addTarget(self, action: #selector(handleSliderMovement(_:)), for: .valueChanged)
        
        return view
    }()
    
    private(set) lazy var jukeboxButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "chevron.right")
        config.attributedTitle = AttributedString(
            String(localized: "jukebox_button"),
            attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Urbanist", size: 20)!])
        )
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        
        config.contentInsets = .init(top: 12, leading: 0, bottom: 0, trailing: 0)
        
        let view = UIButton(configuration: config)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTouchJukeboxButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var sfxTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Urbanist", size: 20)
        view.text = String(localized: "sfx_button")
        view.textColor = .white
        
        return view
    }()
    
    private(set) lazy var sfxSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = .menuYellow
        view.tintColor = UIColor(white: 1, alpha: 0.5)
        view.subviews[0].subviews[0].backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.isOn = UserPreferences.shared.isSoundEffectsEnabled
        
        view.addTarget(self, action: #selector(handleSFXSwitch(_:)), for: .valueChanged)
        
        return view
    }()
    
    private(set) lazy var hapticsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Urbanist", size: 20)
        view.text = String(localized: "haptics_button")
        view.textColor = .white
        
        return view
    }()
    
    private(set) lazy var hapticsSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = .menuYellow
        view.tintColor = UIColor(white: 1, alpha: 0.5)
        view.subviews[0].subviews[0].backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.isOn = UserPreferences.shared.isHapticsEnabled
        
        view.addTarget(self, action: #selector(handleHapticsSwitch(_:)), for: .valueChanged)
        
        return view
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
    
    @objc func didTouchJukeboxButton() {
        SoundEffect.pop.playIfAllowed()
        handleJukeboxButtonTouch()
    }
    
    @objc func handleSliderMovement(_ sender: UISlider) {
        AudioManager.shared.backgroundMusicVolume = sender.value
        UserPreferences.shared.setBackgroundMusicVolume(sender.value)
    }
    
    @objc func handleSFXSwitch(_ sender: UISwitch) {
        SoundEffect.pop.playIfAllowed()
        UserPreferences.shared.isSoundEffectsEnabled = sender.isOn
        UserPreferences.shared.setSoundEffectsEnabled(sender.isOn)
    }
    
    @objc func handleHapticsSwitch(_ sender: UISwitch) {
        SoundEffect.pop.playIfAllowed()
        UserPreferences.shared.isHapticsEnabled = sender.isOn
        UserPreferences.shared.setHapticsEnabled(sender.isOn)
    }
    
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
        addSubview(volumeTitle)
        addSubview(volumeSlider)
        addSubview(jukeboxButton)
        addSubview(sfxTitle)
        addSubview(sfxSwitch)
        addSubview(hapticsTitle)
        addSubview(hapticsSwitch)
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
            volumeTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            volumeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            volumeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            volumeTitle.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: volumeTitle.bottomAnchor, constant: 4),
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            volumeSlider.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            jukeboxButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 30),
            jukeboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            jukeboxButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            jukeboxButton.heightAnchor.constraint(equalToConstant: 48),
            jukeboxButton.imageView!.trailingAnchor.constraint(equalTo: jukeboxButton.trailingAnchor, constant: -20),
            jukeboxButton.titleLabel!.leadingAnchor.constraint(equalTo: jukeboxButton.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            sfxTitle.leadingAnchor.constraint(equalTo: volumeSlider.leadingAnchor),
            sfxTitle.trailingAnchor.constraint(equalTo: sfxSwitch.leadingAnchor),
            sfxTitle.topAnchor.constraint(equalTo: jukeboxButton.bottomAnchor, constant: 30),
            sfxTitle.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            sfxSwitch.trailingAnchor.constraint(equalTo: volumeSlider.trailingAnchor),
            sfxSwitch.topAnchor.constraint(equalTo: sfxTitle.topAnchor),
            sfxSwitch.bottomAnchor.constraint(equalTo: sfxTitle.bottomAnchor),
            sfxSwitch.widthAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            hapticsTitle.topAnchor.constraint(equalTo: sfxSwitch.bottomAnchor, constant: 30),
            hapticsTitle.leadingAnchor.constraint(equalTo: volumeSlider.leadingAnchor),
            hapticsTitle.trailingAnchor.constraint(equalTo: sfxSwitch.leadingAnchor),
            hapticsTitle.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            hapticsSwitch.topAnchor.constraint(equalTo: hapticsTitle.topAnchor),
            hapticsSwitch.bottomAnchor.constraint(equalTo: hapticsTitle.bottomAnchor),
            hapticsSwitch.trailingAnchor.constraint(equalTo: volumeSlider.trailingAnchor),
            hapticsSwitch.widthAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            swipeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            swipeLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}


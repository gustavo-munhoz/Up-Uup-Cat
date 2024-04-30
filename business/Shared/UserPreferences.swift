//
//  UserPreferences.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/04/24.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    private(set) var localSettings: AppSettings?
    
    func setBackgroundMusicVolume(_ value: Float) {
        localSettings?.lastUpdated = Date()
        localSettings?.backgroundMusicVolume = value
        UserDefaults.standard.set(backgroundMusicVolume, forKey: UserDefaultsKeys.backgroundMusicVolume)
        saveSettingsRemotely()
    }
    
    func setBackgroundMusic(_ value: String) {
        localSettings?.lastUpdated = Date()
        localSettings?.selectedBackgroundMusic = value
        UserDefaults.standard.set(selectedBackgroundMusic.rawValue, forKey: UserDefaultsKeys.selectedBackgroundMusic)
        saveSettingsRemotely()
    }
    
    func setSoundEffectsEnabled(_ value: Bool) {
        localSettings?.lastUpdated = Date()
        localSettings?.isSoundEffectsEnabled = value
        UserDefaults.standard.set(isSoundEffectsEnabled, forKey: UserDefaultsKeys.isSoundEffectsEnabled)
        saveSettingsRemotely()
    }
    
    func setHapticsEnabled(_ value: Bool) {
        localSettings?.lastUpdated = Date()
        localSettings?.isHapticsEnabled = value
        UserDefaults.standard.set(isHapticsEnabled, forKey: UserDefaultsKeys.isHapticsEnabled)
        saveSettingsRemotely()
    }
    
    func setAdsRemoved(_ value: Bool) {
        localSettings?.lastUpdated = Date()
        localSettings?.areAdsRemoved = value
        UserDefaults.standard.set(areAdsRemoved, forKey: UserDefaultsKeys.areAdsRemoved)
        saveSettingsRemotely()
    }
    
    func setLocalHighscore(_ value: Int) {
        localSettings?.highScore = value
        GameManager.shared.setPersonalBest(value)
        saveSettingsRemotely()
    }
    
    func setLocalNigiriBalance(_ value: Int) {
        localSettings?.nigiriBalance = value
        GameManager.shared.setNigiriBalance(value)
        saveSettingsRemotely()
    }
    
    var playerId: String?
    
    var backgroundMusicVolume: Float {
        didSet {
            UserDefaults.standard.set(backgroundMusicVolume, forKey: UserDefaultsKeys.backgroundMusicVolume)
        }
    }
    
    var selectedBackgroundMusic: BackgroundMusic {
        willSet {
            selectedBackgroundMusic.stop()
        }
        
        didSet {
            selectedBackgroundMusic.play()
            AudioManager.shared.backgroundMusicVolume = backgroundMusicVolume
            UserDefaults.standard.set(selectedBackgroundMusic.rawValue, forKey: UserDefaultsKeys.selectedBackgroundMusic)
        }
    }
    
    var isSoundEffectsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEffectsEnabled, forKey: UserDefaultsKeys.isSoundEffectsEnabled)
        }
    }
    
    var isHapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: UserDefaultsKeys.isHapticsEnabled)
        }
    }
    
    var hasAccessedBefore: Bool {
        didSet {
            UserDefaults.standard.set(hasAccessedBefore, forKey: UserDefaultsKeys.hasAccessedBefore)
        }
    }
    
    var areAdsRemoved: Bool {
        didSet {
            UserDefaults.standard.set(areAdsRemoved, forKey: UserDefaultsKeys.areAdsRemoved)
        }
    }
    
    var lastUpdated: Date? {
        didSet {
            UserDefaults.standard.set(lastUpdated, forKey: UserDefaultsKeys.lastUpdated)
        }
    }
    
    private init() {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: UserDefaultsKeys.hasAccessedBefore) {
            backgroundMusicVolume = defaults.float(forKey: UserDefaultsKeys.backgroundMusicVolume)
            selectedBackgroundMusic = BackgroundMusic(rawValue: defaults.string(forKey: UserDefaultsKeys.selectedBackgroundMusic) ?? "") ?? .catNipDaze
            isSoundEffectsEnabled = defaults.bool(forKey: UserDefaultsKeys.isSoundEffectsEnabled)
            isHapticsEnabled = defaults.bool(forKey: UserDefaultsKeys.isHapticsEnabled)
            hasAccessedBefore = true
            areAdsRemoved = defaults.bool(forKey: UserDefaultsKeys.areAdsRemoved)
            
        } else {
            backgroundMusicVolume = 1.0
            selectedBackgroundMusic = .catNipDaze
            isSoundEffectsEnabled = true
            isHapticsEnabled = true
            hasAccessedBefore = true
            areAdsRemoved = false
            
            defaults.set(backgroundMusicVolume, forKey: UserDefaultsKeys.backgroundMusicVolume)
            defaults.set(selectedBackgroundMusic.rawValue, forKey: UserDefaultsKeys.selectedBackgroundMusic)
            defaults.set(isSoundEffectsEnabled, forKey: UserDefaultsKeys.isSoundEffectsEnabled)
            defaults.set(isHapticsEnabled, forKey: UserDefaultsKeys.isHapticsEnabled)
            defaults.set(hasAccessedBefore, forKey: UserDefaultsKeys.hasAccessedBefore)
            defaults.set(areAdsRemoved, forKey: UserDefaultsKeys.areAdsRemoved)
        }
        
        if let lastUpdatedDate = defaults.object(forKey: UserDefaultsKeys.lastUpdated) as? Date {
            lastUpdated = lastUpdatedDate
        } else {
            lastUpdated = Date(timeIntervalSince1970: 0)
        }
    }
    
    func loadLocalSettings() -> AppSettings? {
        let dictionary: [String: Any] = [
            "hasAccessedBefore": hasAccessedBefore,
            "backgroundMusicVolume": backgroundMusicVolume,
            "selectedBackgroundMusic": selectedBackgroundMusic.rawValue,
            "isSoundEffectsEnabled": isSoundEffectsEnabled,
            "isHapticsEnabled": isHapticsEnabled,
            "areAdsRemoved": areAdsRemoved,
            "highScore": GameManager.shared.personalBestScore,
            "nigiriBalance": GameManager.shared.nigiriBalance,
            "lastUpdated": lastUpdated ?? Date(timeIntervalSince1970: 0)
        ]
        
        print("Attempting to load local settings with dictionary: \(dictionary)")
        localSettings = AppSettings(dictionary: dictionary)
        
        if localSettings == nil {
            print("Failed to initialize AppSettings with dictionary.")
        }
        
        return localSettings
    }

    
    func updateSettings(with settings: AppSettings) {
        localSettings = AppSettings(dictionary: [
            "hasAccessedBefore": settings.hasAccessedBefore,
            "backgroundMusicVolume": settings.backgroundMusicVolume,
            "selectedBackgroundMusic": settings.selectedBackgroundMusic,
            "isSoundEffectsEnabled": settings.isSoundEffectsEnabled,
            "isHapticsEnabled": settings.isHapticsEnabled,
            "areAdsRemoved": settings.areAdsRemoved,
            "highScore": settings.highScore,
            "nigiriBalance": settings.nigiriBalance,
            "lastUpdated": settings.lastUpdated!
        ])
        
        hasAccessedBefore = settings.hasAccessedBefore
        backgroundMusicVolume = settings.backgroundMusicVolume
        selectedBackgroundMusic = BackgroundMusic(rawValue: settings.selectedBackgroundMusic)!
        isSoundEffectsEnabled = settings.isSoundEffectsEnabled
        isHapticsEnabled = settings.isHapticsEnabled
        areAdsRemoved = settings.areAdsRemoved
        GameManager.shared.setPersonalBest(settings.highScore)
        GameManager.shared.setNigiriBalance(settings.nigiriBalance)
    }
    
    func saveSettingsRemotely() {
        guard let settings = localSettings else { return }
        FirestoreService.shared.save(data: settings, collection: "upuupcat_database", documentId: playerId) { success in
            print(success ? "Remote settings saved successfully." : "Error saving remote settings.")
        }
    }
}

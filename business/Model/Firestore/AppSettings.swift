//
//  AppSettings.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import Foundation
import FirebaseFirestore

struct AppSettings: FirestoreSerializable {
    var hasAccessedBefore: Bool
    var backgroundMusicVolume: Float
    var selectedBackgroundMusic: String
    var isSoundEffectsEnabled: Bool
    var isHapticsEnabled: Bool
    var areAdsRemoved: Bool
    var highScore: Int
    var nigiriBalance: Int
    var lastUpdated: Date?

    init?(dictionary: [String: Any]) {
        guard let hasAccessedBefore = dictionary["hasAccessedBefore"] as? Bool,
              let backgroundMusicVolume = dictionary["backgroundMusicVolume"] as? Float,
              let selectedBackgroundMusic = dictionary["selectedBackgroundMusic"] as? String,
              let isSoundEffectsEnabled = dictionary["isSoundEffectsEnabled"] as? Bool,
              let isHapticsEnabled = dictionary["isHapticsEnabled"] as? Bool,
              let areAdsRemoved = dictionary["areAdsRemoved"] as? Bool,
              let highScore = dictionary["highScore"] as? Int,
              let nigiriBalance = dictionary["nigiriBalance"] as? Int else { return nil }
        
        self.hasAccessedBefore = hasAccessedBefore
        self.backgroundMusicVolume = backgroundMusicVolume
        self.selectedBackgroundMusic = selectedBackgroundMusic
        self.isSoundEffectsEnabled = isSoundEffectsEnabled
        self.isHapticsEnabled = isHapticsEnabled
        self.areAdsRemoved = areAdsRemoved
        self.highScore = highScore
        self.nigiriBalance = nigiriBalance
        
        if let timestamp = dictionary["lastUpdated"] as? Timestamp {
            self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        } else {
            self.lastUpdated = Date(timeIntervalSince1970: 0)
        }
    }
    
    var dictionary: [String: Any] {
        return [
            "hasAccessedBefore": hasAccessedBefore,
            "backgroundMusicVolume": backgroundMusicVolume,
            "selectedBackgroundMusic": selectedBackgroundMusic,
            "isSoundEffectsEnabled": isSoundEffectsEnabled,
            "isHapticsEnabled": isHapticsEnabled,
            "areAdsRemoved": areAdsRemoved,
            "highScore": highScore,
            "nigiriBalance": nigiriBalance,
            "lastUpdated": lastUpdated ?? Date(timeIntervalSince1970: 0)
        ]
    }
}

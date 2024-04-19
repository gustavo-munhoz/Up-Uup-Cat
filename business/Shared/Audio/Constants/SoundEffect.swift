//
//  AudioEffects.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import Foundation

enum SoundEffect: String {
    case snore = "cat-snore"
    case cucumberMove = "cucumber-move"
}

extension SoundEffect {
    var filename: String {
        rawValue + ".wav"
    }
    
    func play() {
        AudioManager.shared.playSoundEffect(effect: self)
    }
    
    func stop() {
        AudioManager.shared.stopSoundEffect(effect: self)
    }
}

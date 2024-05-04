//
//  SoundEffect.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import Foundation

enum SoundEffect: String {
    case snore = "cat-snore"
    case surprise = "surprise"
    case cucumberMove = "cucumber-move"
    case pop = "pop"
    case pickUpNigiri = "nigiri-pickup-pop"
    case pickUpCatnip = "catnip-pickup"
    case jump = "jump"
    case squeakingGlass = "squeaking-glass"
    case catScream = "cat-scream"
    case wingFlap = "wing-flap"
}

extension SoundEffect {
    var filename: String {
        switch self {
            case .pop:
                return rawValue + ".mp3"
                
            default:
                return rawValue + ".wav"
        }
    }
    
    func playIfAllowed(withVolume volume: Float = 1.0, _ completion: @escaping () -> Void = {}) {
        if UserPreferences.shared.isSoundEffectsEnabled {
            AudioManager.shared.setSoundEffectPlayerVolume(self, to: volume)
            AudioManager.shared.playSoundEffect(effect: self)
        }
        
        completion()
    }
    
    func stop(_ completion: @escaping () -> Void = {}) {
        AudioManager.shared.stopSoundEffect(effect: self)
        
        completion() 
    }
}

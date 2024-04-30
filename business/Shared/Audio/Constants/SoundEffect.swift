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
    case claws1 = "claws-1"
    case claws2 = "claws-2"
    case claws3 = "claws-3"
    case squeakingGlass = "squeaking-glass"
    case catScream = "cat-scream"
    case jump1 = "jump-1"
    case jump2 = "jump-2"
    case jump3 = "jump-3"
    case jump4 = "jump-4"
    case jump5 = "jump-5"
    case jump6 = "jump-6"
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
    
    func playIfAllowed(_ completion: @escaping () -> Void = {}) {
        if UserPreferences.shared.isSoundEffectsEnabled {
            AudioManager.shared.playSoundEffect(effect: self)
        }
        
        completion()
    }
    
    func stop(_ completion: @escaping () -> Void = {}) {
        AudioManager.shared.stopSoundEffect(effect: self)
        
        completion() 
    }
}

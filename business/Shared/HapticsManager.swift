//
//  HapticsManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/04/24.
//

import UIKit

struct HapticsManager {
    private static let softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
    private static let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let rigidImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    
    static func playSoftImpact(intensity: CGFloat = 1.0) {
        guard UserPreferences.shared.isHapticsEnabled else { return }
        
        softImpactGenerator.impactOccurred(intensity: intensity)
    }
    
    static func playRigidImpact(intensity: CGFloat = 1.0) {
        guard UserPreferences.shared.isHapticsEnabled else { return }
        
        rigidImpactGenerator.impactOccurred(intensity: intensity)
    }
    
    static func playHeavyImpact(intensity: CGFloat = 1.0) {
        guard UserPreferences.shared.isHapticsEnabled else { return }
        
        heavyImpactGenerator.impactOccurred(intensity: intensity)
    }
}

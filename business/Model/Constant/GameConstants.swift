//
//  GameConstants.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 26/03/24.
//

import CoreGraphics

/// This structure  is destined to keep all the important constant values
/// that are used throughout the game.
struct GC {
    // MARK: - PLAYER
    
    struct PLAYER {
        static let DEFAULT_BOOST_MAX = 95.0
        static let DEFAULT_BOOST_MIN = 5.0
    }
    
    // MARK: - CUCUMBER
    
    struct CUCUMBER {
        static let DEFAULT_MAX_SPEED: Float = 1250
        static let DEFAULT_MAX_ACCELERATION: Float = 425
        static let DEFAULT_MASS: Float = 0.5
        
        static let JUMPING_SPEED: Float = 6000
        
    }
    
    // MARK: - WALLS
    
    struct WALL {
        static let MIN_DIFFICULTY_WIDTH: CGFloat = 800
        static let MAX_DIFFICULTY_WIDTH: CGFloat = 100
        static let MIN_DIFFICULTY_HEIGHT: CGFloat = 1000
        static let MAX_DIFFICULTY_HEIGHT: CGFloat = 80
        static let MIN_DIFFICULTY_SPACING: CGFloat = 50
        static let MAX_DIFFICULTY_SPACING: CGFloat = 250
    }
    
    // MARK: - DIFFICULTY
    
    struct DIFFICULTY {
        static let MAX_DIFFICULTY_HEIGHT: CGFloat = 1000
    }
    
    
    // MARK: - CAMERA
    struct CAMERA {
        static let MIN_CAMERA_SCALE: CGFloat = 1
        static let MAX_CAMERA_SCALE: CGFloat = 2
    }
}

//
//  GameConstants.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 26/03/24.
//

import CoreGraphics
import SpriteKit

/// This structure  is destined to keep all the important constant values
/// that are used throughout the game.
struct GC {
    
    static let GRAVITY: CGVector = CGVector(dx: 0, dy: -9.8)
    
    // MARK: - PLAYER
    
    struct PLAYER {
        static let DEFAULT_BOOST_MAX: CGFloat = 95.0
        static let DEFAULT_BOOST_MIN: CGFloat = 5.0
        static let DEFAULT_MASS: CGFloat = 0.075
        
        struct TEXTURE {
            static let START = SKTexture(imageNamed: "cat_start")
            static let JUMP_FRAME_1 = SKTexture(imageNamed: "cat_jumping_1")
            static let JUMP_FRAME_2 = SKTexture(imageNamed: "cat_jumping_2")
            static let HOLDING_WALL = SKTexture(imageNamed: "cat_holding")
            static let SCARED = SKTexture(imageNamed: "cat_scared")
            
            struct ANIMATION {
                static let JUMP = SKAction.sequence([
                    SKAction.setTexture(GC.PLAYER.TEXTURE.JUMP_FRAME_1),
                    SKAction.wait(forDuration: 1/5),
                    SKAction.setTexture(GC.PLAYER.TEXTURE.JUMP_FRAME_2),
                ])
            }
        }
    }
    
    // MARK: - CUCUMBER
    
    struct CUCUMBER {
        static let DEFAULT_MAX_SPEED: Float = 600
        static let DEFAULT_MAX_ACCELERATION: Float = 150
        static let DEFAULT_MASS: Float = 0.5
        
        static let JUMPING_SPEED: Float = 6000
        
        struct TEXTURE {
            static let CHASING_FRAME_1 = SKTexture(imageNamed: "cucumber_chasing_1")
            static let CHASING_FRAME_2 = SKTexture(imageNamed: "cucumber_chasing_2")
        }
    }
    
    // MARK: - WALLS
    
    struct WALL {
        static let MIN_DIFFICULTY_WIDTH: CGFloat = 800
        static let MAX_DIFFICULTY_WIDTH: CGFloat = 100
        static let MIN_DIFFICULTY_HEIGHT: CGFloat = 1000
        static let MAX_DIFFICULTY_HEIGHT: CGFloat = 80
        static let MIN_DIFFICULTY_SPACING: CGFloat = 50
        static let MAX_DIFFICULTY_SPACING: CGFloat = 250
        
        struct TEXTURE {
            static let TALL = SKTexture(imageNamed: "wall_tall")
            static let LONG = SKTexture(imageNamed: "wall_long")
            static let REGULAR = SKTexture(imageNamed: "wall_regular")
            static let SQUARE = SKTexture(imageNamed: "wall_square")
        }
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

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
    static let GLASS_FORCE: CGVector = CGVector(dx: 0, dy: 75)
    
    // MARK: - PLAYER
    
    struct PLAYER {
        static let DEFAULT_BOOST_MAX: CGFloat = 95.0
        static let DEFAULT_BOOST_MIN: CGFloat = 5.0
        static let DEFAULT_MASS: CGFloat = 0.075
        
        static let PUMPED_BOOST_MAX: CGFloat = 200
        static let PUMPED_BOOST_MIN: CGFloat = 5
        
        
        struct TEXTURE {
            static let START = SKTexture(imageNamed: "cat_start")
            static let PREPARE = SKTexture(imageNamed: "cat_start_prepare")
            static let JUMP_FRAME_1 = SKTexture(imageNamed: "cat_jumping_1")
            static let JUMP_FRAME_2 = SKTexture(imageNamed: "cat_jumping_2")
            static let HOLDING_WALL = SKTexture(imageNamed: "cat_holding")
            static let SCARED = SKTexture(imageNamed: "cat_scared")
            
            struct ANIMATION {
                static let JUMP = SKAction.sequence([
                    .setTexture(GC.PLAYER.TEXTURE.JUMP_FRAME_1),
                    .wait(forDuration: 1.0/5.0),
                    .setTexture(GC.PLAYER.TEXTURE.JUMP_FRAME_2),
                ])
                
                static let GLASS_JUMP = SKAction.sequence([
                    .wait(forDuration: 0.1),
                    .setTexture(GC.PLAYER.TEXTURE.JUMP_FRAME_2),
                ])
                
                let DEATH: SKAction = {
                    let deltaX: Double = [-350, -250, 250, 350].randomElement()!
                    let deltaY: Double = [750, 850, 950, 1050].randomElement()!
                    
                    let rotateAction: SKAction = .customAction(withDuration: 1, actionBlock: { node, elapsedTime in
                        if let sprite = node as? SKSpriteNode {
                            sprite.zRotation = -CGFloat.pi * 2 * elapsedTime
                        }
                    })
                    
                    let moveUp = SKAction.moveBy(x: deltaX, y: deltaY, duration: 0.75)
                    moveUp.timingMode = .easeOut
                    
                    let moveDown = SKAction.moveBy(x: deltaX, y: -1000, duration: 0.4)
                    moveDown.timingMode = .easeIn
                    
                    return .group([
                        .sequence([
                            .setTexture(GC.PLAYER.TEXTURE.SCARED),
                            moveUp, moveDown
                        ]),
                        rotateAction
                    ])
                }()

            }
        }
    }
    
    // MARK: - CUCUMBER
    
    struct CUCUMBER {
        static let DEFAULT_MAX_SPEED: Float = 750
        static let DEFAULT_MIN_SPEED: Float = 100
        static let DEFAULT_MAX_ACCELERATION: Float = 200
        static let DEFAULT_MIN_ACCELERATION: Float = 150
        static let DEFAULT_MASS: Float = 0.5
        
        static let JUMPING_SPEED: Float = 10e6
        
        struct TEXTURE {
            static let CHASING_FRAME_1 = SKTexture(imageNamed: "cucumber_chasing_1")
            static let CHASING_FRAME_2 = SKTexture(imageNamed: "cucumber_chasing_2")
        }
    }
    
    // MARK: - WALLS
    
    struct WALL {
        static let MIN_DIFFICULTY_WIDTH: CGFloat = 700
        static let MAX_DIFFICULTY_WIDTH: CGFloat = 100
        static let MIN_DIFFICULTY_HEIGHT: CGFloat = 500
        static let MAX_DIFFICULTY_HEIGHT: CGFloat = 40
        static let MIN_DIFFICULTY_SPACING: CGFloat = 15
        static let MAX_DIFFICULTY_SPACING: CGFloat = 150
        
        struct MATERIAL_PROBABILITY {
            static let NORMAL: CGFloat = 0.8
            static let GLASS: CGFloat = 0.2
        }
        
        struct COLLECTIBLE_PROBABILITY {
            static let NIGIRI: CGFloat = 0.05
            static let CATNIP: CGFloat = 0.025
        }
        
        struct TEXTURE {
            struct NORMAL {
                static let TALL = SKTexture(imageNamed: "normal_tall")
                static let LONG = SKTexture(imageNamed: "normal_long")
                static let REGULAR = SKTexture(imageNamed: "normal_regular")
                static let SQUARE = SKTexture(imageNamed: "normal_square")
            }
            
            struct GLASS {
                static let TALL = SKTexture(imageNamed: "glass_tall")
                static let SQUARE = SKTexture(imageNamed: "glass_square")
                static let LONG = SKTexture(imageNamed: "glass_long")
                static let REGULAR = SKTexture(imageNamed: "glass_regular")
            }
        }
    }
    
    // MARK: - DIFFICULTY
    
    struct DIFFICULTY {
        static let MAX_DIFFICULTY_HEIGHT: CGFloat = 1500
    }
    
    
    // MARK: - CAMERA
    struct CAMERA {
        static let MIN_CAMERA_SCALE: CGFloat = 1.25
        static let MAX_CAMERA_SCALE: CGFloat = 2.25
    }
    
    // MARK: - HUD
    struct HUD {
        static let PAUSE_BUTTON: String = "pauseButton"
        static let HUD_NAME: String = "HUD"
    }
    
    // MARK: - GAME CENTER
    
    struct GAME_CENTER {
        struct LEADERBOARDS {
            static let HIGHEST_HEIGHTS_ID = "Leaderboards_01"
        }
    }
}

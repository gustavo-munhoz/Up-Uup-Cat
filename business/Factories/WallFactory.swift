//
//  WallFactory.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 21/03/24.
//

import SpriteKit
import GameplayKit

class WallFactory {
    var frame: CGRect
    var wallParameters = WallParameters()
    var lastWallMaxY: CGFloat
    
    init(frame: CGRect, cameraPositionY: CGFloat, firstWallsHeight: CGFloat) {
        self.frame = frame
        self.lastWallMaxY = firstWallsHeight
    }
    
    func createWalls() -> [WallNode] {
        var walls: [WallNode] = []
        let numberOfWalls = Int.random(in: 3...12)
        var currentLineMaxY: CGFloat = lastWallMaxY

        for _ in 0..<numberOfWalls {
            let wallWidth = CGFloat(wallParameters.widthDistribution.nextInt())
            let wallHeight = CGFloat(wallParameters.heightDistribution.nextInt())
            
            let wallXPosition = CGFloat.random(in: (-1.5 * frame.maxX)...(1.5 * frame.maxX))
            
            let spacing = CGFloat(wallParameters.spacingDistribution.nextInt())
            let wallYPosition = lastWallMaxY + spacing + wallHeight / 2

            var isOverlapping = false
            for existingWall in walls {
                if abs(existingWall.position.y - wallYPosition) < (wallHeight + existingWall.size.height) / 2 {
                    if abs(existingWall.position.x - wallXPosition) < (wallWidth + existingWall.size.width) / 2 {
                        isOverlapping = true
                        break
                    }
                }
            }

            if !isOverlapping {
                let materialRandomizer = CGFloat.random(in: 0..<1)
                let material: WallMaterial
                
                if materialRandomizer <= GC.WALL.MATERIAL_PROBABILITY.GLASS {
                    material = .glass
                } else {
                    material = .normal
                }
                
                let newWall = WallNode(size: CGSize(width: wallWidth, height: wallHeight), material: material)
                
                let collectibleRoll = CGFloat.random(in: 0..<1)
                if collectibleRoll < GC.WALL.COLLECTIBLE_PROBABILITY.NIGIRI {
                    newWall.addCollectible(.nigiri)
                } else if collectibleRoll < (GC.WALL.COLLECTIBLE_PROBABILITY.NIGIRI + GC.WALL.COLLECTIBLE_PROBABILITY.CATNIP) {
                    newWall.addCollectible(.catnip)
                }
                
                newWall.position = CGPoint(x: wallXPosition, y: wallYPosition)
                newWall.zPosition = 1
                walls.append(newWall)

                currentLineMaxY = max(currentLineMaxY, wallYPosition + wallHeight / 2)
            }
        }

        lastWallMaxY = currentLineMaxY

        return walls
    }

    
    func adjustWallParameters(forProgress progress: CGFloat) {
        let newMaxWidth = Int(GC.WALL.MIN_DIFFICULTY_WIDTH - progress * (GC.WALL.MIN_DIFFICULTY_WIDTH - GC.WALL.MAX_DIFFICULTY_WIDTH))
        let newMaxHeight = Int(GC.WALL.MIN_DIFFICULTY_HEIGHT - progress * (GC.WALL.MIN_DIFFICULTY_HEIGHT - GC.WALL.MAX_DIFFICULTY_HEIGHT))
        let newMinSpacing = Int(GC.WALL.MIN_DIFFICULTY_SPACING + progress * (GC.WALL.MAX_DIFFICULTY_SPACING - GC.WALL.MIN_DIFFICULTY_SPACING))

        wallParameters.widthDistribution = GKRandomDistribution(lowestValue: Int(GC.WALL.MAX_DIFFICULTY_WIDTH), highestValue: newMaxWidth)
        wallParameters.heightDistribution = GKRandomDistribution(lowestValue: Int(GC.WALL.MAX_DIFFICULTY_HEIGHT), highestValue: newMaxHeight)
        wallParameters.spacingDistribution = GKRandomDistribution(lowestValue: newMinSpacing, highestValue: Int(GC.WALL.MAX_DIFFICULTY_SPACING))
    }
}


// TODO: Change to gaussian distribution
struct WallParameters {
    var widthDistribution: GKRandomDistribution
    var heightDistribution: GKRandomDistribution
    var spacingDistribution: GKRandomDistribution
    
    init() {
        widthDistribution = GKRandomDistribution(lowestValue: Int(GC.WALL.MAX_DIFFICULTY_WIDTH), highestValue: Int(GC.WALL.MIN_DIFFICULTY_WIDTH))
        heightDistribution = GKRandomDistribution(lowestValue: Int(GC.WALL.MAX_DIFFICULTY_HEIGHT), highestValue: Int(GC.WALL.MIN_DIFFICULTY_HEIGHT))
        spacingDistribution = GKRandomDistribution(lowestValue: Int(GC.WALL.MIN_DIFFICULTY_SPACING), highestValue: Int(GC.WALL.MAX_DIFFICULTY_SPACING))
    }
}

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
    var lastWallTopY: CGFloat = 0
    
    var lastWallMaxY: CGFloat = 0
    
    init(frame: CGRect, cameraPositionY: CGFloat) {
        self.frame = frame
        self.lastWallTopY = cameraPositionY
    }
    
    func createInitialWalls() -> [WallNode] {
        let firstWall = WallNode(size: CGSize(width: 3 * frame.width, height: frame.height), material: .normal)
        firstWall.position = CGPoint(x: frame.midX, y: frame.midY - frame.height * 0.25)
        firstWall.zPosition = 1
        
        let spacingBetweenWalls = CGFloat(wallParameters.spacingDistribution.nextInt())
        
        let secondWall = WallNode(size: CGSize(width: 3 * frame.width, height: frame.height), material: .normal)
        let secondWallYPosition = firstWall.position.y + frame.height/2 + spacingBetweenWalls
        secondWall.position = CGPoint(x: frame.midX, y: secondWallYPosition)
        secondWall.zPosition = 1

        return [firstWall, secondWall]
    }

    func createWalls() -> [WallNode] {
        var walls: [WallNode] = []
        let numberOfWalls = Int.random(in: 1...4)
        var currentMaxY = lastWallMaxY

        for _ in 0..<numberOfWalls {
            let wallWidth = CGFloat(wallParameters.widthDistribution.nextInt())
            let wallHeight = CGFloat(wallParameters.heightDistribution.nextInt())
            
            let wallXPosition = CGFloat.random(in: (-frame.maxX * 1.5)...(frame.maxX * 1.5))
            
            let wallYPosition = lastWallMaxY + CGFloat(wallParameters.spacingDistribution.nextInt()) + wallHeight / 2

            let newWall = WallNode(size: CGSize(width: wallWidth, height: wallHeight), material: .normal)
            newWall.position = CGPoint(x: wallXPosition, y: wallYPosition)
            newWall.zPosition = 1
            walls.append(newWall)

            
            currentMaxY = max(lastWallMaxY, wallYPosition + wallHeight / 2)
        }
        lastWallMaxY = currentMaxY

        return walls
    }
    
    func createWall() -> WallNode {
        let wallWidth = CGFloat(wallParameters.widthDistribution.nextInt())
        let wallHeight = CGFloat(wallParameters.heightDistribution.nextInt())
        
        let wallSpacing = CGFloat(wallParameters.spacingDistribution.nextInt())
        
        let wallXPosition = CGFloat.random(in: frame.minX...frame.maxX)
        
        let wallYPosition = lastWallTopY + wallSpacing + wallHeight / 2
        
        let newWall = WallNode(size: CGSize(width: wallWidth, height: wallHeight), material: .normal)
        newWall.position = CGPoint(x: wallXPosition, y: wallYPosition)
        newWall.zPosition = 1
        
        lastWallTopY = wallYPosition + wallHeight / 2

        return newWall
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

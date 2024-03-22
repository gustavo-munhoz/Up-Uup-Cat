//
//  WallFactory.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 21/03/24.
//

import SpriteKit

class WallFactory {
    var frame: CGRect
    var cameraPositionY: CGFloat
    
    init(frame: CGRect, cameraPositionY: CGFloat) {
        self.frame = frame
        self.cameraPositionY = cameraPositionY
    }
    
    func createWall() -> WallNode {
        let wallWidth = CGFloat.random(in: 100...200)
        let wallHeight = CGFloat.random(in: 300...600)
        let wallXPosition = CGFloat.random(in: frame.minX...frame.maxX)
        let wallYPosition = cameraPositionY + CGFloat.random(in: frame.height...(frame.height * 1.005)) + wallHeight / 2

        let newWall = WallNode(size: CGSize(width: wallWidth, height: wallHeight), material: .normal)
        newWall.position = CGPoint(x: wallXPosition, y: wallYPosition)
        newWall.zPosition = 1
        
        return newWall
    }
    
    func createInitialWalls() -> [WallNode] {
        var walls: [WallNode] = []
        let numberOfWalls = 3

        var currentWallTopY = -frame.height * 0.5

        for i in 0..<numberOfWalls {
            if i == 0 {
                let wall = WallNode(size: CGSize(width: 3 * frame.width, height: frame.height), material: .normal)
                wall.position = CGPoint(x: frame.midX, y: frame.midY)
                wall.zPosition = 1
                walls.append(wall)
                currentWallTopY += wall.frame.height + CGFloat.random(in: 50...150)
                continue
            }
            
            let wallWidth = CGFloat.random(in: 150...500)
            let wallHeight = CGFloat.random(in: 600...800)
            
            let wallXPosition = CGFloat.random(in: frame.minX + wallWidth / 2...frame.maxX - wallWidth / 2)
            
            let wall = WallNode(size: CGSize(width: wallWidth, height: wallHeight), material: .normal)
            wall.position = CGPoint(x: wallXPosition, y: currentWallTopY + wallHeight / 2)
            wall.zPosition = 1
            walls.append(wall)
            
            currentWallTopY += wallHeight + CGFloat.random(in: 50...150)
        }

        return walls
    }
}

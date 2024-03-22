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
}

//
//  ArrowNode.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 30/03/24.
//

import SpriteKit

class ArrowNode: SKShapeNode {
    var catPosition: CGPoint
    
    init(catPosition: CGPoint) {
        self.catPosition = catPosition
        super.init()
        
        strokeColor = .white
        lineWidth = 2.5
        zPosition = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(start: CGPoint, end: CGPoint) {
        let direction = CGVector(dx: start.x - end.x, dy: start.y - end.y)
        let arrowTip = CGPoint(x: catPosition.x + direction.dx, y: catPosition.y + direction.dy)
        
        path = UIBezierPath.arrow(
            from: catPosition,
            to: arrowTip,
            headLength: 15,
            maxLength: 150
        )
        .cgPath
    }
    
    func updateBasePosition(to newPosition: CGPoint) {
        self.catPosition = newPosition
    }
}

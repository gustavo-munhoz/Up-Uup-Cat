//
//  UIBezierPath+ext.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 30/03/24.
//

import UIKit

extension UIBezierPath {
    static func arrow(from start: CGPoint, to end: CGPoint, headLength: CGFloat, maxLength: CGFloat? = nil) -> UIBezierPath {
        let path = UIBezierPath()

        var dx = end.x - start.x
        var dy = end.y - start.y
        let length = hypot(dx, dy)
        
        if let maxLength = maxLength {
            if length > maxLength {
                let scalingFactor = maxLength / length
                dx *= scalingFactor
                dy *= scalingFactor
            }
        }
        
        let end = CGPoint(x: start.x + dx, y: start.y + dy)
        
        path.move(to: start)
        path.addLine(to: CGPoint(x: start.x + (end.x - start.x), y: start.y + (end.y - start.y)))
        
        let angle = atan2(end.y - start.y, end.x - start.x)
        
        path.move(to: end)
         
        let headLine1 = CGPoint(
            x: end.x - headLength * cos(angle + .pi / 4),
            y: end.y - headLength * sin(angle + .pi / 4)
        )
        let headLine2 = CGPoint(
            x: end.x - headLength * cos(angle - .pi / 4),
            y: end.y - headLength * sin(angle - .pi / 4)
        )
        
        path.addLine(to: headLine1)
        path.move(to: end)
        path.addLine(to: headLine2)
        
        return path
    }
}

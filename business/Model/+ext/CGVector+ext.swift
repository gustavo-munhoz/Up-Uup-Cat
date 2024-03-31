//
//  CGVector+ext.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import Foundation

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    func normalized() -> CGVector {
        let length = self.length()
        return CGVector(dx: dx / length, dy: dy / length)
    }
    
    static func * (lhs: CGVector, rhs: Float) -> CGVector {
        return CGVector(dx: lhs.dx * CGFloat(rhs), dy: lhs.dy * CGFloat(rhs))
    }
}

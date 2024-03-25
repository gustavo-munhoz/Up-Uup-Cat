//
//  CGVector+ext.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 25/03/24.
//

import Foundation

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx * dx + dy * dy)
        return CGVector(dx: dx / length, dy: dy / length)
    }
}

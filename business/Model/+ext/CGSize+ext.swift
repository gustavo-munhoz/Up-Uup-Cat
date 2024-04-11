//
//  CGSize+ext.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 04/04/24.
//

import Foundation

extension CGSize {
    init(widthAndHeight: CGFloat) {
        self.init(width: widthAndHeight, height: widthAndHeight)
    }
    
    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

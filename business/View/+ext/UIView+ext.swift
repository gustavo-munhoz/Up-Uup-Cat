//
//  UIView+ext.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 27/04/24.
//

import UIKit

extension UIView{
    func rotate(duration: CGFloat = 1) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

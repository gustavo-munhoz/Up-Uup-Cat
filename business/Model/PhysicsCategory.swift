//
//  PhysicsCategory.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1
    static let wall: UInt32 = 0x1 << 1
    static let floor: UInt32 = 0x1 << 2
}

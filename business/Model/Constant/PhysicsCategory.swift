//
//  PhysicsCategory.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

struct PhysicsCategory {
    static let player: UInt32 = 0
    static let wall: UInt32 = 0x1
    static let enemy: UInt32 = 0x1 << 1
    static let collectible: UInt32 = 0x1 << 2
}

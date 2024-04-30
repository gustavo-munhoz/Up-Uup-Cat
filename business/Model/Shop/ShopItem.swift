//
//  ShopItem.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import Foundation
import StoreKit

struct ShopItem {
    var title: String
    var price: String
    var description: String
    var imageName: String
    var type: ShopItemType
    var isAvailable: Bool
}

enum ShopItemType {
    case inAppPurchase(SKProduct)
    case virtualGood(VirtualGood)
    case other
}

struct VirtualGood {
    var title: String
    var description: String
    var cost: Int
    var imageName: String
}

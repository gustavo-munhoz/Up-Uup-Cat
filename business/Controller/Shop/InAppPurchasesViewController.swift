//
//  InAppPurchasesViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 28/04/24.
//

import UIKit

class InAppPurchasesViewController: UIViewController {
    
    private var inAppPurchasesView = InAppPurchasesView()
    
    override func loadView() {
        view = inAppPurchasesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


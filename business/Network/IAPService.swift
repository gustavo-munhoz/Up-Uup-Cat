//
//  IAPService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 29/04/24.
//

import StoreKit
import Combine

class IAPService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPService()
    var products: [SKProduct] = []
    
    private(set) var didReceiveResponse = PassthroughSubject<SKProductsResponse, Never>()
    private(set) var didRestorePurchases = PassthroughSubject<Bool, Never>()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["dev.mnhz.upuupcat.removeads"])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        didReceiveResponse.send(response)
    }
    
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                // Handle the purchase or restore
                if transaction.payment.productIdentifier == "dev.mnhz.upuupcat.removeads" {
                    UserPreferences.shared.setAdsRemoved(true)
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.areAdsRemoved)
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                // Handle the failed transaction
            default:
                break
            }
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        didRestorePurchases.send(true)
        print("All restorations processed.")
    }

    private func handleRestoration(transaction: SKPaymentTransaction) {
        if transaction.payment.productIdentifier == "dev.mnhz.upuupcat.removeads" {
            UserPreferences.shared.setAdsRemoved(true)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.areAdsRemoved)
        }
    }
}

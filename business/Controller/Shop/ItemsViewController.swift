//
//  ItemsViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 28/04/24.
//

import UIKit
import Combine
import StoreKit

class ItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var itemsView = ItemsView()
    private var cancellables = Set<AnyCancellable>()
    
    var items: [ShopItem] = []
    
    override func loadView() {
        view = itemsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsView.collectionView.delegate = self
        itemsView.collectionView.dataSource = self
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        IAPService.shared.didReceiveResponse
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                self?.updateItems(with: response.products)
            }
            .store(in: &cancellables)
        
        IAPService.shared.didRestorePurchases
            .receive(on: RunLoop.main)
            .sink { [weak self] didReceive in
                if didReceive {
                    self?.updateItems(with: IAPService.shared.products)
                    self?.itemsView.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: NO FUTURO, NÃO IRÁ HAVER SÓ PRODUTOS DA LOJA.
    private func updateItems(with products: [SKProduct]) {
        var tmp: [ShopItem] = []
        for product in products {
            if product.productIdentifier == "dev.mnhz.upuupcat.removeads" {
                let item = ShopItem(
                    title: product.localizedTitle,
                    price: UserDefaults.standard.bool(forKey: UserDefaultsKeys.areAdsRemoved) ?
                        String(localized: "item_purchased") : localizedPrice(for: product) ?? "$ \(product.price.doubleValue)",
                    description: product.localizedDescription,
                    imageName: "remove_ads_icon",
                    type: .inAppPurchase(product),
                    isAvailable: !UserDefaults.standard.bool(forKey: UserDefaultsKeys.areAdsRemoved)
                )
                tmp.append(item)
            }
        }
        self.items = tmp
        self.itemsView.collectionView.reloadData()
    }
    
    func localizedPrice(for product: SKProduct) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]

        switch item.type {
            case .inAppPurchase(let product):
                if product.productIdentifier == "dev.mnhz.upuupcat.removeads" {
                    guard item.isAvailable else { return }
    
                    IAPService.shared.buyProduct(product)
                    
                    items[indexPath.row] = ShopItem(
                        title: product.localizedTitle,
                        price: String(localized: "item_purchased"),
                        description: product.localizedDescription,
                        imageName: "remove_ads_icon",
                        type: .inAppPurchase(product),
                        isAvailable: false
                    )
                }
                
            case .virtualGood(let good):
                handleVirtualGoodPurchase(good)
            case .other:
                handleOtherItemSelection(item)
        }
    }
    
    func handleVirtualGoodPurchase(_ good: VirtualGood) {
        // Implementar a lógica para comprar bens virtuais
    }

    func handleOtherItemSelection(_ item: ShopItem) {
        // Implementar outras ações, como mudar configurações ou desbloquear funcionalidades
    }
}

//
//  PaymentNewVM.swift
//  Baby Monitor
//
//  Created by Andreas on 31.08.2022.
//

import Foundation
import Adapty


class PaymentNewVM: ObservableObject {
    
    @Published var isTrialEnabled = false
    @Published var fetchingProducts = true
    @Published var isActiveSub = false
    @Published var products: [ProductModel] = []
    
    private var paywall: PaywallModel?
    
    init() {
        self.fetchProducts()
        self.checkIsActiveSub()
    }
    
    func checkIsActiveSub() {
        Adapty.getPurchaserInfo { [weak self] model, error in
            guard let isActive = model?.accessLevels["premium"]?.isActive else { return }
            self?.isActiveSub = isActive
        }
    }
    
    func fetchProducts() {
        fetchingProducts = true
        Adapty.getPaywalls { [weak self] paywalls, productModels, error in
            self?.paywall = paywalls?.first
            guard let productModels = productModels else { return }
            self?.products = productModels
            self?.fetchingProducts = false
        }
    }
    
    func makePurchase(with product: ProductModel) {
        guard let paywall = paywall else { return }
        Adapty.logShowPaywall(paywall)
        print(paywall.products.count)
        
        Adapty.makePurchase(product: product) { [weak self] purchaserInfo, reciept, appleRecieptParametrs, productModel, error in
            if let error = error {
                UDService.shared.deactivateSub()
            }
            
            let isActive = purchaserInfo?.accessLevels["premium"]?.isActive ?? false
            if isActive {
                UDService.shared.activateSub()
                self?.isActiveSub = isActive
            }
        }
    }
    
    func restore() {
        Adapty.restorePurchases { [weak self] purchaserInfo, reciept, appleRecieptParametrs, error in
            if let error = error {
                UDService.shared.deactivateSub()
            }
            
            let isActive = purchaserInfo?.accessLevels["premium"]?.isActive ?? false
            if isActive {
                UDService.shared.activateSub()
                self?.isActiveSub = isActive
            }
        }
    }
    
    func toggleTrial() async {
        isTrialEnabled = !isTrialEnabled
        fetchingProducts = true
    }
    
    
}

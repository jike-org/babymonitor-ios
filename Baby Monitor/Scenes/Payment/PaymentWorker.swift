//
//  PaymentWorker.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import StoreKit

class PaymentService {
    
    var products: [SKProduct] = []
    private let iapService: IAPService
    private var selectedProductID: String?
    
    init(iapService: IAPService = IAPService.shared) {
        self.iapService = iapService
    }
    
//    func fetchProducts(completion: @escaping ([SKProduct], String?) -> Void) {
//        iapService.fetchProducts()
//        completion(products, selectedProductID)
//    }
    
    func selectProduct(id: String, completion: @escaping ([SKProduct], String?) -> Void) {
        selectedProductID = id
        print(products.count)
        completion(products, selectedProductID)
        iapService.purchase(productWith: selectedProductID)
    }
    
}

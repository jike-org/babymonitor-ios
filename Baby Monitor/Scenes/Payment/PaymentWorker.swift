//
//  PaymentWorker.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Adapty

class PaymentService {
    
    private let iapService: IAPService
    private var selectedProductID: String?
    
    init(iapService: IAPService = IAPService.shared) {
        self.iapService = iapService
    }
    
    func fetchProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        Adapty.getPaywalls { paywalls, productModels, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let productModels = productModels else { return }
            completion(.success(productModels))
        }
    }
    
    func makePurchase(with product: ProductModel, completion: @escaping (Result<Void, Error>) -> Void) {
        Adapty.makePurchase(product: product) { purchaserInfo, reciept, appleRecieptParametrs, productModel, error in
            if let error = error {
                UDService.shared.deactivateSub()
                completion(.failure(error))
            }
            
            let isActive = purchaserInfo?.accessLevels["premium"]?.isActive ?? false
            if isActive {
                UDService.shared.activateSub()
                completion(.success(()))
            }
        }
    }
    
    func restore(completion: @escaping (Result<Void, Error>) -> Void) {
        Adapty.restorePurchases { purchaserInfo, reciept, appleRecieptParametrs, error in
            if let error = error {
                UDService.shared.deactivateSub()
                completion(.failure(error))
            }
            
            let isActive = purchaserInfo?.accessLevels["premium"]?.isActive ?? false
            if isActive {
                UDService.shared.activateSub()
                completion(.success(()))
            }
        }
    }
    
}

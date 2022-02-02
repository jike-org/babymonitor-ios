//
//  PaymentInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import StoreKit

protocol PaymentBusinessLogic {
    func makeRequest(request: Payment.Model.Request.RequestType)
}

class PaymentInteractor: PaymentBusinessLogic {
    
    var presenter: PaymentPresentationLogic?
    lazy var service = PaymentService()
    
    func makeRequest(request: Payment.Model.Request.RequestType) {
        switch request {
        case .checkTrialAvalabilty:
            presenter?.presentData(response: .presentTimer)
        case .fetchProducts:
            service.fetchProducts { [weak self] result in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTariffs(result: result, selectedProduct: nil))
            }
        case .makePurchase(product: let product):
            service.makePurchase(with: product) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.presenter?.presentData(response: .presentFailed(error: error))
                case .success(_):
                    self.presenter?.presentData(response: .presentSuccess)
                }
            }
        case .restore:
            service.restore { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.presenter?.presentData(response: .presentFailed(error: error))
                case .success(_):
                    self.presenter?.presentData(response: .presentSuccess)
                }
            }
        }
    }
}

// MARK: - IAP Service Delegate

extension PaymentInteractor: IAPServiceDelegate {
    
    func onTransactionFailed(_ error: Error) {
        presenter?.presentData(response: .presentFailed(error: error))
    }
    
    func onTransactionSuccess() {
        presenter?.presentData(response: .presentSuccess)
    }
    
    func onTransactionResctored() {
        presenter?.presentData(response: .presentRestored)
    }
    
    func productsFetched(_ products: [SKProduct]) {
    }
    
}

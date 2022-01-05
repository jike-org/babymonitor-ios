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
        case .selectTariff(id: let id):
            service.selectProduct(id: id, completion: { [weak self] products, selected in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTariffs(tariffs: products, selectedProduct: selected))
            })
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
        service.products = products
        presenter?.presentData(response: .presentTariffs(tariffs: products, selectedProduct: nil))
    }
    
}

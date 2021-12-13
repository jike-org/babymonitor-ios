//
//  PaymentInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentBusinessLogic {
    func makeRequest(request: Payment.Model.Request.RequestType)
}

class PaymentInteractor: PaymentBusinessLogic {
    
    var presenter: PaymentPresentationLogic?
    var service: PaymentService?
    
    func makeRequest(request: Payment.Model.Request.RequestType) {
        if service == nil {
            service = PaymentService()
        }
        switch request {
        case .checkTrialAvalabilty:
            presenter?.presentData(response: .presentTimer)
        }

    }
    
}

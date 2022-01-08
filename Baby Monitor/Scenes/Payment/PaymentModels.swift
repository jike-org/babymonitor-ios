//
//  PaymentModels.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import StoreKit

enum Payment {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkTrialAvalabilty
                case selectTariff(id: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentTimer
                case presentTariffs(tariffs: [SKProduct], selectedProduct: String?)
                case presentSuccess
                case presentFailed(error: Error)
                case presentRestored
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTimer(time: String)
                case displatAlert(message: String)
                case displayBuySuccess
                case displayTariffs(viewModel: PaymentViewModel)
            }
        }
    }
    
}

struct PaymentViewModel {
    struct Tariff: PaymentCellViewModel {
        var isBought: Bool
        var totalAmount: String
        var priceDescription: String
        var isSelected: Bool
        var tariffID: String
    }
    
    let tariffs: [Tariff]
}

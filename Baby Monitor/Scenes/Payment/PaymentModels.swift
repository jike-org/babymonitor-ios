//
//  PaymentModels.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Adapty

enum Payment {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkTrialAvalabilty
//                case selectTariff(id: String)
                case fetchProducts
                case makePurchase(product: ProductModel)
                case restore
            }
        }
        struct Response {
            enum ResponseType {
                case presentTimer
                case presentTariffs(result: Result<[ProductModel], Error>, selectedProduct: String?)
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
        var productModel: ProductModel
    }
    
    let tariffs: [Tariff]
}

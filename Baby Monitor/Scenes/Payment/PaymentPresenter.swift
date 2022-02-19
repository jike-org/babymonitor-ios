//
//  P[aymentPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Adapty

protocol PaymentPresentationLogic {
    func presentData(response: Payment.Model.Response.ResponseType)
}

class PaymentPresenter: PaymentPresentationLogic {
    
    weak var viewController: PaymentDisplayLogic?
    
    func presentData(response: Payment.Model.Response.ResponseType) {
        switch response {
        case .presentTimer:
            startTimer(durationInSeconds: 10000)
        case .presentTariffs(let res, let selectedProduct):
            switch res {
            case .failure(let error):
                viewController?.displayData(viewModel: .displatAlert(message: error.localizedDescription))
            case .success(let products):
                let cells = products.map { self.productToTariffViewModel($0, selectedProduct) }
                let viewModel = PaymentViewModel.init(tariffs: cells)
                viewController?.displayData(viewModel: .displayTariffs(viewModel: viewModel))
            }
        case .presentSuccess:
            viewController?.displayData(viewModel: .displayBuySuccess)
        case .presentFailed(error: let error):
            viewController?.displayData(viewModel: .displatAlert(message: error.localizedDescription))
        case .presentRestored:
            viewController?.displayData(viewModel: .displatAlert(message: "Payment restored"))
        }
    }
    
    private func productToTariffViewModel(_ product: ProductModel, _ selectedProduct: String?) -> PaymentViewModel.Tariff {
//        let price = "$\(product.price.doubleValue / 100)" + "/ \(product.subscriptionPeriod?.description ?? "")"
        
        let price = priceStringFor(product: product)
        let isSelected = product.skProduct?.productIdentifier == selectedProduct ?? nil
        return PaymentViewModel.Tariff.init(isBought: UDService.shared.isSub(),
                                            totalAmount: price,
                                            priceDescription: product.localizedTitle,
                                            isSelected: isSelected,
                                            productModel: product)
    }
    
    private func priceStringFor(product: ProductModel) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .currency
        numFormatter.locale = product.skProduct?.priceLocale
        
        guard
            let num = product.skProduct?.price,
            let res = numFormatter.string(from: num)
        else { return ""}

        return res
    }
    
    private func startTimer(durationInSeconds: Int) {
        var count = durationInSeconds
//        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
//            guard
//                count >= 0,
//                let self = self
//            else {
//                timer.invalidate()
//                return
//            }
//            var times: [String] = []
//            let seconds = (count % 3600) % 60
//            let minutes = count / 60 % 60
//            let hours = count / 3600
//            times.append("\(hours)")
//            times.append("\(minutes)")
//            times.append("\(seconds)")
//            count -= 1
//            let time = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//            self.viewController?.displayData(viewModel: .displayTimer(time: time))
//        }
//        timer.fire()
        
        
        let timer1 = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard
                count >= 0,
                let self = self
            else {
                timer.invalidate()
                return
            }
            var times: [String] = []
            let seconds = (count % 3600) % 60
            let minutes = count / 60 % 60
            let hours = count / 3600
            times.append("\(hours)")
            times.append("\(minutes)")
            times.append("\(seconds)")
            count -= 1
            let time = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.viewController?.displayData(viewModel: .displayTimer(time: time))
        }
        
        RunLoop.main.add(timer1, forMode: .common)
        
        timer1.fire()
    }
    
    private func timerCompletion() {
        
    }
    
}


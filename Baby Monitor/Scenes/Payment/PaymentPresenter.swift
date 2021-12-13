//
//  P[aymentPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentPresentationLogic {
    func presentData(response: Payment.Model.Response.ResponseType)
}

class PaymentPresenter: PaymentPresentationLogic {
    weak var viewController: PaymentDisplayLogic?
    
    func presentData(response: Payment.Model.Response.ResponseType) {
        switch response {
        case .presentTimer:
            startTimer(durationInSeconds: 10000)
        }
    }
    
    private func startTimer(durationInSeconds: Int) {
        var count = durationInSeconds
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
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
        timer.fire()
    }
    
}


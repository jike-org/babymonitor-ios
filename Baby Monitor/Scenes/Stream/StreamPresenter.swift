//
//  StreamPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StreamPresentationLogic {
    func presentData(response: Stream.Model.Response.ResponseType)
}

class StreamPresenter: StreamPresentationLogic {
    
    weak var viewController: StreamDisplayLogic?
    
    private var secondsToSleep = 3
    
    func presentData(response: Stream.Model.Response.ResponseType) {
        switch response {
        case .presentTokenGeneration(result: let result):
            switch result {
            case .failure(let error):
                viewController?.displayData(viewModel: .showAlert(message: error.localizedDescription))
            case .success(let response):
                viewController?.displayData(viewModel: .saveToken(token: response.token))
            }
        case .presentConnected:
            startSleepTimer()
        }
    }
    
    private func startSleepTimer() {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.secondsToSleep <= 0 {
                timer.invalidate()
                self.viewController?.displayData(viewModel: .sleep)
                return
            }

            self.secondsToSleep -= 1
        }
        
        RunLoop.main.add(timer, forMode: .common)
        
        timer.fire()
    }
    
}

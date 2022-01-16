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
    
    func presentData(response: Stream.Model.Response.ResponseType) {
        switch response {
        case .presentTokenGeneration(result: let result):
            switch result {
            case .failure(let error):
                viewController?.displayData(viewModel: .showAlert(message: error.localizedDescription))
            case .success(let response):
                viewController?.displayData(viewModel: .saveToken(token: response.token))
            }
        }
    }
    
}

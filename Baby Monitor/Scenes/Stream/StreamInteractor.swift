//
//  StreamInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StreamBusinessLogic {
    func makeRequest(request: Stream.Model.Request.RequestType)
}

class StreamInteractor: StreamBusinessLogic {
    
    var presenter: StreamPresentationLogic?
    var service: StreamService?
    
    func makeRequest(request: Stream.Model.Request.RequestType) {
        if service == nil {
            service = StreamService()
        }
        
        switch request {
        case .generateToken(let channelID, let role):
            service?.generateToken(channelID: channelID, role: role, completion: { [weak self] result in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTokenGeneration(result: result))
            })
        case .connected:
            presenter?.presentData(response: .presentConnected)
        }
    }
    
}

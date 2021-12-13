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
    }
    
}

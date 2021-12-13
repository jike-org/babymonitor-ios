//
//  StartInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartBusinessLogic {
    func makeRequest(request: Start.Model.Request.RequestType)
}

class StartInteractor: StartBusinessLogic {
    
    var presenter: StartPresentationLogic?
    var service: StartService?
    
    func makeRequest(request: Start.Model.Request.RequestType) {
        if service == nil {
            service = StartService()
        }
    }
    
}

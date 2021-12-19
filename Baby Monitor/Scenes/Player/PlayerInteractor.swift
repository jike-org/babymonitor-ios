//
//  PlayerInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PlayerBusinessLogic {
    func makeRequest(request: Player.Model.Request.RequestType)
}

class PlayerInteractor: PlayerBusinessLogic {
    
    var presenter: PlayerPresentationLogic?
    var service: PlayerService?
    
    func makeRequest(request: Player.Model.Request.RequestType) {
        if service == nil {
            service = PlayerService()
        }
        
        
    }
    
}

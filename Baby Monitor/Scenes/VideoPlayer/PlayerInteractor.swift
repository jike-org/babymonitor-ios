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
        
        switch request {
        case .startFreeTimer:
            service?.startTimer(completion: { [weak self] in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentEndFreeTimer)
            })
        case .generateToken(channelID: let channelID, role: let role):
            service?.generateToken(channelID: channelID, role: role, completion: { [weak self] result in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTokenGeneration(result: result))
            })
        }
    }
    
}

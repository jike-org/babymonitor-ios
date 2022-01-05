//
//  PlayerPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PlayerPresentationLogic {
    func presentData(response: Player.Model.Response.ResponseType)
}

class PlayerPresenter: PlayerPresentationLogic {
    weak var viewController: PlayerDisplayLogic?
    
    func presentData(response: Player.Model.Response.ResponseType) {
    }
    
}

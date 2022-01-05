//
//  AudioPlayerPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 28.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AudioPlayerPresentationLogic {
    func presentData(response: AudioPlayer.Model.Response.ResponseType)
}

class AudioPlayerPresenter: AudioPlayerPresentationLogic {
    weak var viewController: AudioPlayerDisplayLogic?
    
    func presentData(response: AudioPlayer.Model.Response.ResponseType) {
    }
    
}

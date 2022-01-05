//
//  AudioPlayerInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 28.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AudioPlayerBusinessLogic {
    func makeRequest(request: AudioPlayer.Model.Request.RequestType)
}

class AudioPlayerInteractor: AudioPlayerBusinessLogic {
    
    var presenter: AudioPlayerPresentationLogic?
    var service: AudioPlayerWorker?
    
    func makeRequest(request: AudioPlayer.Model.Request.RequestType) {
        if service == nil {
            service = AudioPlayerWorker()
        }
    }
    
}

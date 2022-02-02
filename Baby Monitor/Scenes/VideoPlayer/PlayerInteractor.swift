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
    
    private var countOfFreeAvailableSeconds = 900
    
    func makeRequest(request: Player.Model.Request.RequestType) {
        if service == nil {
            service = PlayerService()
        }
        
        switch request {
        case .generateToken(channelID: let channelID, role: let role):
            service?.generateToken(channelID: channelID, role: role, completion: { [weak self] result in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTokenGeneration(result: result))
            })
        case .startSession:
            if !UDService.shared.isSub() {
                startTimer()
            }
        }
    }
    
    private func startTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.countOfFreeAvailableSeconds < 0 {
                timer.invalidate()
                self.presenter?.presentData(response: .presentEndFreeTimer)
                return
            }
            
            var times: [String] = []
            let seconds = (self.countOfFreeAvailableSeconds % 3600) % 60
            let minutes = self.countOfFreeAvailableSeconds / 60 % 60
            let hours = self.countOfFreeAvailableSeconds / 3600
            times.append("\(hours)")
            times.append("\(minutes)")
            times.append("\(seconds)")

            let time = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.presenter?.presentData(response: .presentRemainingTime(time: time))
            self.countOfFreeAvailableSeconds -= 1
        }
        timer.fire()
    }
    
}

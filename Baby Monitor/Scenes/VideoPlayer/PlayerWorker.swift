//
//  PlayerWorker.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class PlayerService {
    
    private var countOfFreeAvailableMinutes = 15
    
    func startTimer(completion: @escaping () -> Void) {
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] timer in
            guard
                let self = self,
                self.countOfFreeAvailableMinutes >= 0
            else {
                timer.invalidate()
                completion()
                return
            }

            self.countOfFreeAvailableMinutes -= 1
        }
        timer.fire()
    }

}

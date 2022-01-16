//
//  PlayerWorker.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class PlayerService {
    
    private let repo: UsersRepoProtocol
    private var countOfFreeAvailableMinutes = 15
    private var token: String?
    
    init(repo: UsersRepoProtocol = UsersRepo.init()) {
        self.repo = repo
    }
    
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
    
    func generateToken(channelID: String, role: UserRole, completion: @escaping (Result<CreateTokenResponse, Error>) -> Void) {
        repo.generateToken(channelID: channelID, role: role.rawValue, userId: "2") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                self.token = response.token
                completion(.success(response))
            }
        }
    }

}

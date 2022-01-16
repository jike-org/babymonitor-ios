//
//  StreamWorker.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class StreamService {
    
    private let repo: UsersRepoProtocol
    private var token: String?
    
    init(repo: UsersRepoProtocol = UsersRepo.init()) {
        self.repo = repo
    }
    
    
    func generateToken(channelID: String, role: UserRole, completion: @escaping (Result<CreateTokenResponse, Error>) -> Void) {
        repo.generateToken(channelID: channelID, role: role.rawValue, userId: "1") { [weak self] result in
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

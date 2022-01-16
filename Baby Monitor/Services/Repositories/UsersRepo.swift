//
//  UsersRepo.swift
//  Baby Monitor
//
//  Created by Andreas on 16.01.2022.
//

import Foundation

protocol UsersRepoProtocol {
    func generateToken(channelID: String, role: String, userId: String, completion: @escaping (Result<CreateTokenResponse, Error>) -> Void)
}

class UsersRepo {
    
    private let networking: Networking
    
    init(networking: Networking = NetworkService.shared) {
        self.networking = networking
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        do {
            guard
                let data = from
            else { return nil }
            let response = try decoder.decode(type.self, from: data)
            return response
            
        } catch {
            print(error)
            return nil
        }
    }
    
}

// MARK: - Users Repo Protocol

extension UsersRepo: UsersRepoProtocol {
    
    func generateToken(channelID: String, role: String, userId: String, completion: @escaping (Result<CreateTokenResponse, Error>) -> Void) {
        let params = [
            "channelID": channelID,
            "role": role,
            "userID": userId
        ]
        
        networking.request(path: API.Endpoints.createToken, params: params) { data, error, statusCode in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let response = self.decodeJSON(type: CreateTokenResponse.self, from: data)
            else {
                completion(.failure(HttpErrors.empty))
                return
            }
            
            switch statusCode {
            case 200: completion(.success(response))
            default: completion(.failure(HttpErrors.unknownError(statusCode: statusCode ?? 500)))
            }
        }
    }
    
    
}

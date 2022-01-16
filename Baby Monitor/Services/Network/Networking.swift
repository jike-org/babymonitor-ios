//
//  Networking.swift
//  Baby Monitor
//
//  Created by Andreas on 16.01.2022.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?, Int?) -> Void)
    func postRequest(path: String, body: Data, completion: @escaping (Data?, Error?, Int?) -> Void)
    func postRequest(path: String, params: [String: String], completion: @escaping (Data?, Error?, Int?) -> Void)
}

class NetworkService {
    
    static let shared = NetworkService()
    private let userDefaultService: UDService
    
    private init(userDefaultService: UDService = UDService.shared) {
        self.userDefaultService = userDefaultService
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        
        components.host = API.host
        components.scheme = API.scheme
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        components.path = path
        
        return components.url!
    }
}

// MARK: - Networking
extension NetworkService: Networking {
    
    func postRequest(path: String, body: Data, completion: @escaping (Data?, Error?, Int?) -> Void) {
        var allParams: [String: String] = [:]
        allParams["version"] = API.version
        allParams["os"] = API.os
        let url = self.url(from: path, params: allParams)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        let token = userDefaultService.getToken() ?? ""
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = body
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func postRequest(path: String, params: [String: String], completion: @escaping (Data?, Error?, Int?) -> Void) {
        var allParams: [String: String] = params
        allParams["version"] = API.version
        allParams["os"] = API.os
        let url = self.url(from: path, params: allParams)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        let token = userDefaultService.getToken() ?? ""
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?, Int?) -> Void) {
        var allParams = params
        allParams["version"] = API.version
        allParams["os"] = API.os
        let url = self.url(from: path, params: allParams)
        var request = URLRequest(url: url)
//        let token = userDefaultService.getToken() ?? ""
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?, Int?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let myResponse = response as? HTTPURLResponse
                let statusCode = myResponse?.statusCode
                completion(data, error, statusCode)
            }
        }
    }
    
}

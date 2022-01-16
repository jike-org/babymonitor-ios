//
//  CreateTokenResponse.swift
//  Baby Monitor
//
//  Created by Andreas on 16.01.2022.
//

import Foundation

struct CreateTokenResponse: Decodable {
    let token: String?
}

enum UserRole: String {
    case publisher = "PUBLISHER"
    case subscriber = "SUBSCRIBER"
}

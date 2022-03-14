//
//  StreamModels.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Stream {
    
    enum Model {
        struct Request {
            enum RequestType {
                case generateToken(channelID: String, role: UserRole)
                case connected
            }
        }
        struct Response {
            enum ResponseType {
                case presentTokenGeneration(result: Result<CreateTokenResponse, Error>)
                case presentConnected
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case showAlert(message: String)
                case saveToken(token: String?)
                case sleep
            }
        }
    }
    
}

//
//  PlayerModels.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Player {
    
    enum Model {
        struct Request {
            enum RequestType {
                case startSession
                case generateToken(channelID: String, role: UserRole)
            }
        }
        struct Response {
            enum ResponseType {
                case presentRemainingTime(time: String)
                case presentEndFreeTimer
                case presentTokenGeneration(result: Result<CreateTokenResponse, Error>)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayRemainingTime(time: String)
                case displatEndFreeTimer
                case showAlert(message: String)
                case saveToken(token: String?)
            }
        }
    }
    
}



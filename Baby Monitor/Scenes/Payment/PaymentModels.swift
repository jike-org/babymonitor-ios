//
//  PaymentModels.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Payment {
    
    enum Model {
        struct Request {
            enum RequestType {
                case checkTrialAvalabilty
            }
        }
        struct Response {
            enum ResponseType {
                case presentTimer
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTimer(time: String)
            }
        }
    }
    
}

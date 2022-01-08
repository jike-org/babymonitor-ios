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
                case startFreeTimer
            }
        }
        struct Response {
            enum ResponseType {
                case presentEndFreeTimer
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displatEndFreeTimer
            }
        }
    }
    
}

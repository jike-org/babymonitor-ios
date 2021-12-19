//
//  StreamPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StreamPresentationLogic {
    func presentData(response: Stream.Model.Response.ResponseType)
}

class StreamPresenter: StreamPresentationLogic {
    weak var viewController: StreamDisplayLogic?
    
    func presentData(response: Stream.Model.Response.ResponseType) {
    }
    
}

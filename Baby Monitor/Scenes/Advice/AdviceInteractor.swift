//
//  AdviceInteractor.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AdviceBusinessLogic {
  func makeRequest(request: Advice.Model.Request.RequestType)
}

class AdviceInteractor: AdviceBusinessLogic {

  var presenter: AdvicePresentationLogic?
  var service: AdviceService?
  
  func makeRequest(request: Advice.Model.Request.RequestType) {
    if service == nil {
      service = AdviceService()
    }
  }
  
}

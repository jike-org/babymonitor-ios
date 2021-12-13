//
//  AdvicePresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AdvicePresentationLogic {
  func presentData(response: Advice.Model.Response.ResponseType)
}

class AdvicePresenter: AdvicePresentationLogic {
  weak var viewController: AdviceDisplayLogic?
  
  func presentData(response: Advice.Model.Response.ResponseType) {
  
  }
  
}

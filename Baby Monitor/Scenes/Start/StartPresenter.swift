//
//  StartPresenter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartPresentationLogic {
  func presentData(response: Start.Model.Response.ResponseType)
}

class StartPresenter: StartPresentationLogic {
  weak var viewController: StartDisplayLogic?
  
  func presentData(response: Start.Model.Response.ResponseType) {
  }
  
}

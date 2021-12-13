//
//  AdviceViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AdviceDisplayLogic: AnyObject {
    func displayData(viewModel: Advice.Model.ViewModel.ViewModelData)
}

class AdviceViewController: UIViewController, AdviceDisplayLogic {
    
    var interactor: AdviceBusinessLogic?
    var router: (NSObjectProtocol & AdviceRoutingLogic)?

    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayData(viewModel: Advice.Model.ViewModel.ViewModelData) {
    }
    
}

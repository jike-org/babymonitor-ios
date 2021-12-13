//
//  PaymentRouter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentRoutingLogic {
    func navigateToLegals()
}

class PaymentRouter: NSObject, PaymentRoutingLogic {
    
    weak var viewController: PaymentViewController?
    
    // MARK: Routing
    
    func navigateToLegals() {
        let vc = LagalsVC()
        vc.modalPresentationStyle = .automatic
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}

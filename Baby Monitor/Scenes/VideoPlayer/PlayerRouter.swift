//
//  PlayerRouter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PlayerRoutingLogic {
    func navigateToSubscribeScreen()
}

class PlayerRouter: NSObject, PlayerRoutingLogic {
    
    
    weak var viewController: PlayerViewController?
    
    // MARK: Routing
    
    func navigateToSubscribeScreen() {
        let assembly = PaymentAssembly()
        let vc = assembly.assemble()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}

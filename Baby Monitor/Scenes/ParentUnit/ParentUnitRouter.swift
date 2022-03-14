//
//  ParentUnitRouter.swift
//  Baby Monitor
//
//  Created by Andreas on 14.03.2022.
//

import Foundation

protocol ParentUnitRoutingLogic {
    func navigateToSubscribeScreen()
}

class ParentUnitRouter: NSObject, ParentUnitRoutingLogic {
    
    weak var viewController: PlayerViewController?
    
    // MARK: Routing
    
    func navigateToSubscribeScreen() {
        let assembly = PaymentAssembly()
        let vc = assembly.assemble()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
}

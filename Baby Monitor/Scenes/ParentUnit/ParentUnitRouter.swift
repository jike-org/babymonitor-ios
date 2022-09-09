//
//  ParentUnitRouter.swift
//  Baby Monitor
//
//  Created by Andreas on 14.03.2022.
//

import Foundation
import SwiftUI

protocol ParentUnitRoutingLogic {
    func navigateToSubscribeScreen()
}

class ParentUnitRouter: NSObject, ParentUnitRoutingLogic {
    
    weak var viewController: PlayerViewController?
    
    // MARK: Routing
    
    func navigateToSubscribeScreen() {
        let vc = UIHostingController(rootView: PaymentNewScreen(shouldShowCloseBtn: true))
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}

//
//  StartRouter.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartRoutingLogic {
    func navigateToPlayerScene()
    func navigateToBabyScene()
    func navigateToPaymentScene()
}

class StartRouter: NSObject, StartRoutingLogic {
    
    
    
    weak var viewController: StartViewController?
    
    // MARK: Routing
    
    func navigateToPaymentScene() {
//        let storyboard = UIStoryboard(name: "PaymentViewcontroller", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "PaymentViewController") { coder in
//            let assembly = PaymentAssembly()
//            return assembly.assemble(coder: coder)
//        } as! PaymentViewController
//        vc.modalPresentationStyle = .fullScreen
//        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateToBabyScene() {
        let storyboard = UIStoryboard(name: "BabyUnitViewController", bundle: nil)
        guard
            let vc = storyboard.instantiateViewController(identifier: "BabyUnitViewController") as? BabyUnitViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateToPlayerScene() {
        let storyboard = UIStoryboard(name: "PlayerViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PlayerViewController") { coder in
            let assembly = PlayerAssembly()
            return assembly.assemble(coder: coder)
        } as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}

//
//  PaymentAssembly.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import Foundation

class PaymentAssembly {
    
    func assemble() -> PaymentViewController {
//        let vc = PaymentViewController(coder: coder)
        let vc = PaymentViewController()
        let presenter = createPresenter()
        let interactor = createInteractor()
        let router = createRouter()
        
        vc.interactor = interactor
        vc.router = router
        
        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        
//        IAPService.shared.delegate = interactor
        
        return vc
    }
    
    private func createPresenter() -> PaymentPresenter {
        .init()
    }
    
    private func createInteractor() -> PaymentInteractor {
        .init()
    }
    
    private func createRouter() -> PaymentRouter {
        .init()
    }
    
}

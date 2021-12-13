//
//  AdviceAsembly.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import Foundation

class AdviceAssembly {
    
    func assemble(coder: NSCoder) -> AdviceViewController? {
        let vc = AdviceViewController(coder: coder)
        let presenter = createPresenter()
        let interactor = createInteractor()
        let router = createRouter()
        
        vc?.interactor = interactor
        vc?.router = router
        
        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        
        return vc
    }
    
    private func createPresenter() -> AdvicePresenter {
        .init()
    }
    
    private func createInteractor() -> AdviceInteractor {
        .init()
    }
    
    private func createRouter() -> AdviceRouter {
        .init()
    }
    
}

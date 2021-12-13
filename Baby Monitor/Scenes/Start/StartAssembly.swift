//
//  StartAssembly.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import Foundation

class StartAssembly {
    
    func assemble(coder: NSCoder) -> StartViewController? {
        let interactor = createInteractor()
        let router = createRouter()
        let presenter = createPresenter()
        let vc = StartViewController(coder: coder)
        
        vc?.interactor = interactor
        vc?.router = router
        
        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc
        
        return vc
    }
    
    private func createPresenter() -> StartPresenter {
        return .init()
    }
    
    private func createInteractor() -> StartInteractor {
        return .init()
    }
    
    private func createRouter() -> StartRouter {
        return .init()
    }
    
}

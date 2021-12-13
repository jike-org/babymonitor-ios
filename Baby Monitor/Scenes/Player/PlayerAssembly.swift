//
//  PlayerAssembly.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import Foundation

class PlayerAssembly {
    
    func assemble(coder: NSCoder) -> PlayerViewController? {
        let vc = PlayerViewController(coder: coder)
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
    
    private func createPresenter() -> PlayerPresenter {
        return .init()
    }
    
    private func createInteractor() -> PlayerInteractor {
        return .init()
    }
    
    private func createRouter() -> PlayerRouter {
        return .init()
    }
    
}

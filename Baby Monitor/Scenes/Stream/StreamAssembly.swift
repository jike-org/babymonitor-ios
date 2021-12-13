//
//  StreamAssembly.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import Foundation


class StreamAssembly {
    
    func assemble(coder: NSCoder) -> StreamViewController? {
        let vc = StreamViewController(coder: coder)
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
    
    private func createPresenter() -> StreamPresenter {
        return .init()
    }
    
    private func createInteractor() -> StreamInteractor {
        return .init()
    }
    
    private func createRouter() -> StreamRouter {
        return .init()
    }
    
}

//
//  AudioPlayerAssembly.swift
//  Baby Monitor
//
//  Created by Andreas on 28.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

class AudioPlayerAssembly {
    
    func assemble(coder: NSCoder) -> AudioPlayerViewController? {
        let vc = AudioPlayerViewController(coder: coder)
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
    
    private func createPresenter() -> AudioPlayerPresenter {
        return .init()
    }
    
    private func createInteractor() -> AudioPlayerInteractor {
        return .init()
    }
    
    private func createRouter() -> AudioPlayerRouter {
        return .init()
    }
    
}

//
//  Menu.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import UIKit
import Adapty
import SwiftUI

class Menu: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Adapty.delegate = self

        buildInactiveSubTabbar()
        checkPremiumActive()

        tabBar.tintColor = .customPurple
    }
    
    func checkPremiumActive() {
        Adapty.getPurchaserInfo { [weak self] purchaserInfo, error in
            guard let self = self else { return }
            
            if let error = error {
                UDService.shared.deactivateSub()
                self.buildInactiveSubTabbar()
            }
            
            let isActiveSub = purchaserInfo?.accessLevels["premium"]?.isActive ?? false
            
            if isActiveSub {
                UDService.shared.activateSub()
                self.buildActiveSubTabbar()
            }
        }
    }
    
    private func buildActiveSubTabbar() {
        viewControllers = [
            createStartScreen(),
            createMusicScreen(),
            createAdviceScreen()
        ]
    }
    
    private func buildInactiveSubTabbar() {
        viewControllers = [
            createStartScreen(),
            createMusicScreen(),
            createAdviceScreen(),
            createSubscribtionScreen()
        ]
    }
    
    private func createStartScreen() -> StartViewController {
        let storyboard = UIStoryboard(name: "StartViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "StartViewController") { coder in
            let assembly = StartAssembly()
            return assembly.assemble(coder: coder)
        } as! StartViewController
        let item = UITabBarItem(title: "Video", image: #imageLiteral(resourceName: "videoIcon"), tag: 0)
        vc.tabBarItem = item
        return vc
    }
    
    private func createMusicScreen() -> AudioPlayerViewController {
        let storyboard = UIStoryboard(name: "AudioPlayerViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AudioPlayerViewController") { coder in
            let assembly = AudioPlayerAssembly()
            return assembly.assemble(coder: coder)
        } as! AudioPlayerViewController
        let item = UITabBarItem(title: "Music", image: #imageLiteral(resourceName: "musicIcon"), tag: 0)
        vc.tabBarItem = item
        return vc
    }
    
    private func createAdviceScreen() -> AdviceViewController {
        let storyboard = UIStoryboard(name: "AdviceViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AdviceViewController") { coder in
            let assembly = AdviceAssembly()
            return assembly.assemble(coder: coder)
        } as! AdviceViewController
        let item = UITabBarItem(title: "Advice", image: #imageLiteral(resourceName: "adviceIcon"), tag: 0)
        vc.tabBarItem = item
        return vc
    }
    
    private func createSubscribtionScreen() -> UIViewController {
        let hosting = UIHostingController(rootView: PaymentNewScreen(shouldShowCloseBtn: false))
        let item = UITabBarItem(title: "Subscribe", image: #imageLiteral(resourceName: "paymentIcon"), tag: 0)
        hosting.tabBarItem = item
        return hosting
    }
    
}

extension Menu: AdaptyDelegate {
    
    func didReceiveUpdatedPurchaserInfo(_ purchaserInfo: PurchaserInfoModel) {
        checkPremiumActive()
    }
    
    func didReceivePromo(_ promo: PromoModel) {
    }
    
    
}

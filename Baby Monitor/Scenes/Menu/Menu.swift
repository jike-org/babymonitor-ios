//
//  Menu.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import UIKit

class Menu: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createStartScreen(),
            createMusicScreen(),
            createAdviceScreen(),
            createSubscribtionScreen()
        ]
        
        tabBar.tintColor = .customPurple
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
    
    private func createMusicScreen() -> PlayerViewController {
        let storyboard = UIStoryboard(name: "PlayerViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PlayerViewController") { coder in
            let assembly = PlayerAssembly()
            return assembly.assemble(coder: coder)
        } as! PlayerViewController
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
    
    private func createSubscribtionScreen() -> PaymentViewController {
        let storyboard = UIStoryboard(name: "PaymentViewcontroller", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PaymentViewController") { coder in
            let assembly = PaymentAssembly()
            return assembly.assemble(coder: coder)
        } as! PaymentViewController
        let item = UITabBarItem(title: "Subscribe", image: #imageLiteral(resourceName: "paymentIcon"), tag: 0)
        vc.tabBarItem = item
        return vc
    }
    
}

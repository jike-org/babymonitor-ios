//
//  UIViewController+Extension.swift
//  Baby Monitor
//
//  Created by Andreas on 05.01.2022.
//

import UIKit

extension UIViewController {
    
    
    func showErrorAlert(with message: String?) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
}

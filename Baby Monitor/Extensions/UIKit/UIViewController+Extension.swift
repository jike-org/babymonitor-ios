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
    
    func showAlert(with message: String?, completion: @escaping () -> Void) {
        let ac = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            completion()
        })
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func showJoinAlert(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Connect to session", message: "Enter channel ID for connection to baby unit session", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Connect", style: .default) { [weak alert] _ in
            guard let text = alert?.textFields![0].text else { return }
            
            completion(text)
//            self.joinAgoraChannel(channelID: text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showInviteAlert(channelID: Int) {
        let ac = UIAlertController(title: "Connection info", message: "To connect a parent unit to this session, enter the code: \(channelID) on the parent's device", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func onlyOneTrackAlert() {
        let ac = UIAlertController(title: "Only one track", message: "One free plan available only one track to play. Buy premium subscription to remove limits.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        ac.addAction(okAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    
}

//
//  PaymentFooterCell.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import UIKit

class PaymentFooterCell: UITableViewCell {
    
    static let reuseID = "PaymentFooterCell"
    
    @IBOutlet private weak var benefitsStackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        benefitsStackView.layer.cornerRadius = 10
        benefitsStackView.layer.masksToBounds = true
    }

    var restorePurchaseCB: (() -> Void)?
    var termOfUseCB: (() -> Void)?
    var privacyPoliceCB: (() -> Void)?
    
    @IBAction func termOfUseTapped() {
        termOfUseCB?()
    }
    
    @IBAction func privacyPolicyTapped() {
        privacyPoliceCB?()
    }
    
    @IBAction private func restore() {
        IAPService.shared.restoreCompletedTransaction()
    }
    
}

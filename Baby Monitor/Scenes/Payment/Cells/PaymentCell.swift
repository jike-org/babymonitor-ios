//
//  PaymentCell.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import UIKit

protocol PaymentCellViewModel {
    var totalAmount: String  { get }
    var isSelected: Bool { get }
}

class PaymentCell: UITableViewCell {
    
    static let reuseID = "PaymentCell"
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var selectView: UIView!
    @IBOutlet private weak var totalAmount: UILabel!
    @IBOutlet private weak var totalAmountTwo: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.backgroundColor = .clear
        cardView.layer.cornerRadius = 15
        selectView.layer.cornerRadius = 15
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.customPinkColor.cgColor
        
        selectionStyle = .none
    }
    
    func apply(viewModel: PaymentCellViewModel) {
        totalAmount.text = viewModel.totalAmount
        totalAmountTwo.text = "Billed weekly: \(viewModel.totalAmount)"
        
        selectView.backgroundColor = viewModel.isSelected ? .customPurple : .clear
        selectView.backgroundColor = viewModel.isSelected ? .customPurple : .clear
        totalAmount.textColor = viewModel.isSelected ? .white : .darkGray
        totalAmountTwo.textColor = viewModel.isSelected ? .white : .darkGray
    }
    
}

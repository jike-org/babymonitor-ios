//
//  PaymentCell.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import UIKit

protocol PaymentCellViewModel {
    var totalAmount: String  { get }
    var priceDescription: String { get }
    var isSelected: Bool { get }
    var isBought: Bool { get }
}

class PaymentCell: UITableViewCell {
    
    static let reuseID = "PaymentCell"
    
    @IBOutlet private weak var selectView: UIView!
    @IBOutlet private weak var totalAmount: UILabel!
    @IBOutlet private weak var tariffDescription: UILabel!
    @IBOutlet private weak var boughtState: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectView.layer.cornerRadius = 15
        selectView.layer.borderWidth = 0.69
        selectView.layer.borderColor = UIColor.customPurple.cgColor
        
        selectionStyle = .none
        
//        inProgressStateLabel.isHidden = true
//        boughtState.isHidden = true
    }
    
    func apply(viewModel: PaymentCellViewModel) {
        totalAmount.text = viewModel.totalAmount
        tariffDescription.text = viewModel.priceDescription
        selectView.backgroundColor = viewModel.isSelected ? .mainWhite : .clear
        boughtState.isHidden = !viewModel.isBought
    }
    
    func showPogress() {
//        inProgressStateLabel.isHidden = false
    }
    
    func hideProgress() {
//        inProgressStateLabel.isHidden = true
    }
    
//    func toggleSelection() {
//        selectView.backgroundColor = isSelected ? .mainWhite : .clear
//    }
    
}

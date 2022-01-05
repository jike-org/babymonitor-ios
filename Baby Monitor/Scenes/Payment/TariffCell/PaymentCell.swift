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
}

class PaymentCell: UITableViewCell {
    
    static let reuseID = "PaymentCell"
    
    @IBOutlet private weak var selectView: UIView!
    @IBOutlet private weak var totalAmount: UILabel!
    @IBOutlet private weak var tariffDescription: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectView.layer.cornerRadius = 15
        selectView.layer.borderWidth = 0.69
        selectView.layer.borderColor = UIColor.customPurple.cgColor
        
        selectionStyle = .none
    }
    
    func apply(viewModel: PaymentCellViewModel) {
        totalAmount.text = viewModel.totalAmount
        tariffDescription.text = viewModel.priceDescription
        selectView.backgroundColor = viewModel.isSelected ? .mainWhite : .clear
    }
    
//    func toggleSelection() {
//        selectView.backgroundColor = isSelected ? .mainWhite : .clear
//    }
    
}

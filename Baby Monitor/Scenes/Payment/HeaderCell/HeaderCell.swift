//
//  HeaderCell.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    static let reuseID = "HeaderCell"
    
    @IBOutlet private weak var timerLabel: UILabel!
    
    func setTimer(time: String) {
        timerLabel.text = "The trial time expires in: \(time)"
    }
    
}

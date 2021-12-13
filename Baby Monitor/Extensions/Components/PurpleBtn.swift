//
//  PurpleBtn.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//

import UIKit

class PurpleBtn: UIButton {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 18
        backgroundColor = .customPurple
        tintColor = .white
    }
    
    
}

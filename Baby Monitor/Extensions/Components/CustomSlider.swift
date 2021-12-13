//
//  CustomSlider.swift
//  Baby Monitor
//
//  Created by Andreas on 13.12.2021.
//

import UIKit

class CustomSlider: UISlider {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setThumbImage(#imageLiteral(resourceName: "thumbSlider"), for: .normal)
        minimumValueImage = #imageLiteral(resourceName: "Volume-Down")
        maximumValueImage = #imageLiteral(resourceName: "Volume-Up")
    }
}

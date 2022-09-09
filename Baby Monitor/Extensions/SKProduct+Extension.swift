//
//  SKProduct.swift
//  Baby Monitor
//
//  Created by Andreas on 09.09.2022.
//

import Foundation
import StoreKit

extension SKProduct {
    
    func priceToString() -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .currency
        numFormatter.locale = self.priceLocale
        
        let num = self.price
        
        guard
            
            let res = numFormatter.string(from: num)
        else { return ""}

        return res
    }
    
    func priceToStringPerMonth() -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .currency
        numFormatter.locale = self.priceLocale
        
        let num = (self.price as Decimal) / 12
        
        guard
            
            let res = numFormatter.string(from: num as NSNumber)
        else { return ""}

        return res
    }
    
}

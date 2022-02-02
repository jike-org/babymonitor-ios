//
//  UDService.swift
//  Baby Monitor
//
//  Created by Andreas on 08.01.2022.
//

import Foundation

class UDService {
    
    static let shared = UDService()
    private init() { }
    
    private let storage = UserDefaults.standard
    
    struct Constants  {
        static let isSub = "isSubscription"
        static let subExpireDate = "subscriptionExpireDate"
        static let freeTimeUsage = "freeTimeUsage"
    }
    
    func setSub() {
        storage.setValue(true, forKey: Constants.isSub)
    }
    
    func activateSub() {
        storage.setValue(true, forKey: Constants.isSub)
    }
    
    func deactivateSub() {
        storage.setValue(false, forKey: Constants.isSub)
    }
    
    func isSub() -> Bool {
        (storage.value(forKey: Constants.isSub) as? Bool) ?? false
    }
    
    func clearData() {
        storage.removeObject(forKey: Constants.isSub)
        storage.removeObject(forKey: Constants.subExpireDate)
        storage.removeObject(forKey: Constants.freeTimeUsage)
    }
    
    
}

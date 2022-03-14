//
//  ParentUnitViewModel.swift
//  Baby Monitor
//
//  Created by Andreas on 14.03.2022.
//

import Foundation

protocol ParentUnitViewModelType: AnyObject {
    var loadState: Box<ParentUnitViewModel.LoadState> { get }
    
    var isTrial: Box<Bool> { get }
    var remainingTime: Box<String> { get }
    
    var audioEffects: Box<[Int32: String]> { get }
    var currentTrack: Box<String> { get }
    
    func playNextTrack()
    func playPreviuosTrack()
    func createToken(completion: @escaping (String, Int) -> Void)
    func connectToSession()
    
}

class ParentUnitViewModel: NSObject, ParentUnitViewModelType {
    
    enum Camera {
        case front
        case main
    }
    
    enum LoadState {
        case error(text: String)
        case success
        case loading
        case notActive
    }
    
    override init() {
        super.init()
        
        let isSub = UDService.shared.isSub()
        isTrial.value = !isSub
        
        if isSub {
            audioEffects.value = [0: "Drops", 1: "Waves", 2: "Forest", 3: "Water in cave", 4: "Rain and thunder", 5: "White noise", 6: "Fireplace"]
        }
    }
    
    var loadState: Box<LoadState> = .init(.notActive)
    var isTrial: Box<Bool> = .init(true)
    var remainingTime: Box<String> = .init("00:00:00")
    var audioEffects: Box<[Int32: String]> = .init([0: "Drops"])
    var currentTrack: Box<String> = .init("Drops")
    
    func createToken(completion: @escaping (String, Int) -> Void) {
    }
    
    func connectToSession() {
    }
    
    func playNextTrack() {
    }
    
    func playPreviuosTrack() {
    }
    
}

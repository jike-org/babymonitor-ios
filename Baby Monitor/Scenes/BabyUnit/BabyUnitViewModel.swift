//
//  BabyUnitViewData.swift
//  Baby Monitor
//
//  Created by Andreas on 20.02.2022.
//

import Foundation
import AVFoundation
import UIKit

protocol BabyUnitViewModelType: AnyObject {
    var channelID: Int { get set }
    var connectionToken: Box<(token: String?, channelID: Int)>? { get }
    var loadState: Box<BabyUnitViewModel.LoadState> { get }
    
    var isVideoEnabled: Box<Bool> { get }
    var isAudioEnabled: Box<Bool> { get }
    
    var currentTrack: Box<(id: Int32, path: String)> { get set }
    var isTrackPlaying: Box<(Bool, id: Int32)> { get }
    var isPlayingStarted: Box<Bool> { get }
    
    var currentCamera: Box<BabyUnitViewModel.Camera> { get set }
    
    var isSleep: Box<Bool> { get }
    
    func playNextTrack()
    func playPreviuosTrack()
    func changeBrightness(to value: Float)
    func switchCamera()
    func stopPlayingTrack()
    func startPlayingTrack()
    func preloadEffects(completion: @escaping ([Int32: String]) -> Void)
    func createToken(completion: @escaping (String, Int) -> Void)
    func startSleepTimer()
}

class BabyUnitViewModel: NSObject, BabyUnitViewModelType {
    
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
    
    var connectionToken: Box<(token: String?, channelID: Int)>?
    var loadState: Box<LoadState> = .init(.notActive)
    var isVideoEnabled: Box<Bool> = .init(true)
    var isAudioEnabled: Box<Bool> = .init(true)
    var currentTrack: Box<(id: Int32, path: String)> = .init( (0, "") )
    var isPlayingStarted: Box<Bool> = .init(false)
    var isTrackPlaying: Box<(Bool, id: Int32)> = .init( (false, 7777) )
    var currentCamera: Box<Camera> = .init(.front)
    var isSleep: Box<Bool> = .init(false)
    var channelID: Int = 0
    
    private var audioEffects: [Int32: String] = [:]
    private var repo: UsersRepoProtocol?
    private let currentUserID: UInt = 1
    private let isSub = UDService.shared.isSub()
    private var secondsToSleep = 30
    private var timer: Timer?
    
    override init() {
        super.init()
        
        repo = UsersRepo.init()
        channelID = Int.random(in: 120000..<999999)
    }
    
    func createToken(completion: @escaping (String, Int) -> Void) {
        loadState.value = .loading
        repo?.generateToken(channelID: "\(channelID)", role: UserRole.publisher.rawValue, userId: "1") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.loadState.value = .error(text: error.localizedDescription)
            case .success(let response):
                completion(response.token!, self.channelID)
                self.loadState.value = .success
            }
            self.loadState.value = .notActive
        }
    }
    
    func preloadEffects(completion: @escaping ([Int32 : String]) -> Void) {
        var effects: [Int32: String] = [:]
        if isSub {
            let allAudio = AudioPaths.allCases.count
            let nums: [Int32] = [0, 1, 2, 3, 4, 5, 6]
            for (id, path) in zip(nums, 0..<allAudio) {
                let name = AudioPaths.allCases[path]
                let filePath = Bundle.main.path(forResource: name.rawValue, ofType: "mp3")
                audioEffects[id] = filePath
                effects[id] = filePath
            }
        } else {
            let filePath = Bundle.main.path(forResource: "Drops", ofType: "mp3")
            audioEffects[0] = filePath
            effects[0] = filePath
        }
        completion(effects)
    }
    
    func playNextTrack() {
        guard isSub else { return }
        
        let current = currentTrack.value.id
        
        if currentTrack.value.id == 0 {
            currentTrack.value = ( 1, audioEffects[1]! )
        } else if currentTrack.value.id == 6 {
            currentTrack.value = ( 0, audioEffects[0]! )
        } else {
            let next = current + 1
            currentTrack.value = ( next, audioEffects[next]! )
        }
    }
    
    func playPreviuosTrack() {
        guard isSub else { return }
        
        let current = currentTrack.value.id
        
        if currentTrack.value.id == 0 {
            currentTrack.value = ( 6, audioEffects[6]! )
        } else if currentTrack.value.id == 6 {
            currentTrack.value = ( 5, audioEffects[5]! )
        } else {
            let next = current - 1
            currentTrack.value = ( next, audioEffects[next]! )
        }
    }
    
    func changeBrightness(to value: Float) {
        switch currentCamera.value {
        case .front: UIScreen.main.brightness = CGFloat(value)
        case .main: AVCaptureDevice.changeTorchLevel(value: value)
        }
    }
    
    func switchCamera() {
        AVCaptureDevice.toggleFlash()
        switch currentCamera.value {
        case .front: currentCamera.value = .main
        case .main: currentCamera.value = .front
        }
    }
    
    func stopPlayingTrack() {
        let trackID = currentTrack.value.id
        isTrackPlaying.value = (false, trackID)
    }
    
    func startPlayingTrack() {
        let trackID = currentTrack.value.id
        isTrackPlaying.value = (true, trackID)
        currentTrack.value = (trackID, audioEffects[trackID]!)
    }
    
    private func dropTimer() {
        timer?.invalidate()
        timer = nil
        secondsToSleep = 30
    }
    
    func startSleepTimer() {
        dropTimer()
        
        timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.secondsToSleep <= 0 {
                self.dropTimer()
                self.isSleep.value = true
                return
            }

            self.secondsToSleep -= 1
        }
        
        guard let timer = timer else { return }
        RunLoop.main.add(timer, forMode: .common)
        
        timer.fire()
    }
    
}

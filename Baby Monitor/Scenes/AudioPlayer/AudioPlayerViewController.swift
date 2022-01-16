//
//  AudioPlayerViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 28.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlayerDisplayLogic: AnyObject {
    func displayData(viewModel: AudioPlayer.Model.ViewModel.ViewModelData)
}

class AudioPlayerViewController: UIViewController, AudioPlayerDisplayLogic {
    
    var interactor: AudioPlayerBusinessLogic?
    var router: (NSObjectProtocol & AudioPlayerRoutingLogic)?
    
    private var myAudio: AVAudioPlayer?
    private var trackNames: [String] = ["Drops", "Waves", "Forest", "Water in cave", "Rain and thunder", "White noise", "Fireplace"]
    private var currentTrackID: Int = 0
    
    @IBOutlet private weak var trackName: UILabel!
    @IBOutlet private weak var playPauseBtn: UIButton!
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
        
        trackName.text = trackNames[currentTrackID]
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupAudio()
    }
    
    func displayData(viewModel: AudioPlayer.Model.ViewModel.ViewModelData) {
    }
    
    private func setupAudio() {
        let trackName = AudioPaths.allCases[currentTrackID].rawValue
        guard let path = Bundle.main.path(forResource: trackName, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            myAudio = try AVAudioPlayer(contentsOf: url)
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            myAudio?.numberOfLoops = -1
            myAudio?.prepareToPlay()
        } catch {
            showErrorAlert(with: "Can`t load track")
        }
    }
    
    private func playPauseAudio() {
    }
    
    // MARK: - IB Actions
    
    @IBAction private func playPausePressed() {
        setupAudio()
        
        if playPauseBtn.isSelected {
            myAudio?.play()
        } else {
            myAudio?.stop()
        }
        
        playPauseBtn.isSelected.toggle()
    }
    
    @IBAction private func playPreviousTrack() {
        
        if currentTrackID == 0 {
            currentTrackID = 6
        } else {
            currentTrackID -= 1
        }
        
        trackName.text = trackNames[currentTrackID]
        
        setupAudio()
        if playPauseBtn.isSelected {
            myAudio?.stop()
        } else {
            myAudio?.play()
        }
    }
    
    @IBAction private func playNextTrack() {
        
        if currentTrackID == 6 {
            currentTrackID = 0
        } else {
            currentTrackID += 1
        }
        
        trackName.text = trackNames[currentTrackID]
        
        setupAudio()
        if playPauseBtn.isSelected {
            myAudio?.stop()
        } else {
            myAudio?.play()
        }
    }
    
    @IBAction private func changeVolume(_ sender: UISlider) {
        myAudio?.setVolume(sender.value, fadeDuration: 1)
    }
    
}

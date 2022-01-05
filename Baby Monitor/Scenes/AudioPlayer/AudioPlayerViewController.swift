//
//  AudioPlayerViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 28.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AgoraRtcKit

protocol AudioPlayerDisplayLogic: AnyObject {
    func displayData(viewModel: AudioPlayer.Model.ViewModel.ViewModelData)
}

class AudioPlayerViewController: UIViewController, AudioPlayerDisplayLogic {
    
    var interactor: AudioPlayerBusinessLogic?
    var router: (NSObjectProtocol & AudioPlayerRoutingLogic)?
    
    private var agoraKit: AgoraRtcEngineKit?
    private var trackNames: [String] = ["White noise", "Waves", "Rain and thunder", "Drops", "Fireplace", "Forest", "Water in cave"]
    private var currentTrackID: Int = 0
    
    @IBOutlet private weak var trackName: UILabel!
//    @IBOutlet private weak var connectionStateLabel: UILabel!
    @IBOutlet private weak var playPauseBtn: UIButton!
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAgora()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showJoinAlert()
        }
        
        view.backgroundColor = .beige
        
        trackName.text = trackNames[currentTrackID]
    }
    
    deinit {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    private func showJoinAlert() {
        let alert = UIAlertController(title: "Connect to session", message: "Enter channel ID for connection to baby unit session", preferredStyle: .alert)
        alert.addTextField()
        
        let action = UIAlertAction(title: "Connect", style: .default) { [weak alert, weak self] _ in
            guard
                let text = alert?.textFields![0].text,
                let self = self
            else { return }
            
            self.joinAgoraChannel(channelID: text)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func setupAgora() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Constants.appID, delegate: self)
        
        let myLet = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        myLet.initialize(to: 1)
        let config = AgoraDataStreamConfig()
        agoraKit?.createDataStream(myLet, config: config)
    }
    
    private func joinAgoraChannel(channelID: String) {
        agoraKit?.joinChannel(byToken: Constants.token,
                              channelId: channelID,
                              info: nil,
                              uid: 0,
                              joinSuccess: nil)
    }
    
    func displayData(viewModel: AudioPlayer.Model.ViewModel.ViewModelData) {
    }
    
    // MARK: - IB Actions
    
    @IBAction private func playPausePressed() {
        if playPauseBtn.isSelected {
            let value = Commands.startSound.description
            let data = Data(value.utf8)
            agoraKit?.sendStreamMessage(1, data: data)
        } else {
            let value = Commands.pauseSound.description
            let data = Data(value.utf8)
            agoraKit?.sendStreamMessage(1, data: data)
        }
        playPauseBtn.isSelected.toggle()
    }
    
    @IBAction private func playPreviousTrack() {
        let value = Commands.previousTrack.description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
        
        if currentTrackID == 0 {
            currentTrackID = 6
        } else {
            currentTrackID -= 1
        }
        
        trackName.text = trackNames[currentTrackID]
    }
    
    @IBAction private func playNextTrack() {
        let value = Commands.nextTrack.description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
        
        if currentTrackID == 0 {
            currentTrackID = 6
        } else {
            currentTrackID -= 1
        }
        
        trackName.text = trackNames[currentTrackID]
    }
    
    @IBAction private func changeVolume(_ sender: UISlider) {
        let value = Commands.changeSound(value: sender.value).description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
    }
    
}

// MARK: - Agora Rtc Engine Delegate

extension AudioPlayerViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
//        connectionStateLabel.text = "Connection stable"
//        connectionStateLabel.textColor = .green
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
//        connectionStateLabel.text = "Waiting for connection..."
//        connectionStateLabel.textColor = .gray
    }
    
}

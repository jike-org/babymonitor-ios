//
//  PlayerViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AgoraRtcKit

protocol PlayerDisplayLogic: AnyObject {
    func displayData(viewModel: Player.Model.ViewModel.ViewModelData)
}

class PlayerViewController: UIViewController, PlayerDisplayLogic {
    
    var interactor: PlayerBusinessLogic?
    var router: (NSObjectProtocol & PlayerRoutingLogic)?
    
    private var remoteView: UIView!
    private var localView: UIView!
    private var agoraKit: AgoraRtcEngineKit?
    private var trackNames: [String] = ["Drops", "Waves", "Forest", "Water in cave", "Rain and thunder", "White noise", "Fireplace"]
    private var currentTrackID: Int = 0
    
    @IBOutlet private weak var brightnessBtn: UIButton!
    @IBOutlet private weak var videoBtn: UIButton!
    @IBOutlet private weak var audioBtn: UIButton!
    @IBOutlet private weak var playPauseBtn: UIButton!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var trackNameLabel: UILabel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
        
        remoteView = UIView()
        view.insertSubview(remoteView, at: 0)
        
        setupVideoCall()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showJoinAlert()
        }
        
        brightnessSlider.isHidden = true
        brightnessSlider.minimumValue = 0.1
        
        trackNameLabel.text = trackNames[currentTrackID]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        remoteView.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        agoraKit?.disableAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        agoraKit?.enableAudio()
    }
    
    deinit {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    func displayData(viewModel: Player.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displatEndFreeTimer:
            agoraKit?.disableAudio()
            agoraKit?.disableVideo()
            agoraKit?.leaveChannel(nil)
            AgoraRtcEngineKit.destroy()
            
            showAlert(with: "On free plan there`re available 15 free minutes viedo stream. Subscrinbe to use app without limits") {
                self.router?.navigateToSubscribeScreen()
            }
        }
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
    
    private func setupVideoCall() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Constants.appID, delegate: self)
        
        agoraKit?.enableVideo()
        agoraKit?.enableAudio()
        
        let myLet = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        myLet.initialize(to: 1)
        let config = AgoraDataStreamConfig()
        agoraKit?.createDataStream(myLet, config: config)
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    private func joinAgoraChannel(channelID: String) {
        agoraKit?.joinChannel(byToken: Constants.token,
                              channelId: channelID,
                              info: nil,
                              uid: 0,
                              joinSuccess: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func dissmissScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func brightnessPressed() {
        brightnessBtn.isSelected.toggle()
        brightnessSlider.isHidden.toggle()
    }
    
    @IBAction private func videoPressed() {
        if videoBtn.isSelected {
            agoraKit?.muteLocalVideoStream(true)
        } else {
            agoraKit?.muteLocalVideoStream(false)
        }
        videoBtn.isSelected.toggle()
        
        let value = Commands.setVideoDisable(value: videoBtn.isSelected).description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
    }
    
    @IBAction private func audioPressed() {
        if audioBtn.isSelected {
            agoraKit?.disableAudio()
        } else {
            agoraKit?.enableAudio()
        }
        audioBtn.isSelected.toggle()
    }
    
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
        
        trackNameLabel.text = trackNames[currentTrackID]
    }
    
    @IBAction private func playNextTrack() {
        let value = Commands.nextTrack.description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
        
        if currentTrackID == 6 {
            currentTrackID = 0
        } else {
            currentTrackID += 1
        }
        
        trackNameLabel.text = trackNames[currentTrackID]
    }
    
    @IBAction private func changeVolume(_ sender: UISlider) {
        let value = Commands.changeSound(value: sender.value).description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
    }
    
    @IBAction private func changeBrightness(_ sender: UISlider) {
        let value = Commands.changeBrightness(value: sender.value).description
        let data = Data(value.utf8)
        agoraKit?.sendStreamMessage(1, data: data)
    }
    
}

// MARK: - Agora Rtc Engine Delegate

extension PlayerViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        interactor?.makeRequest(request: .startFreeTimer)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView

        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
}

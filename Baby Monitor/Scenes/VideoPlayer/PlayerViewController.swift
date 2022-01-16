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
    private var token: String?
    private var localView: UIView!
    private var agoraKit: AgoraRtcEngineKit?
    private var trackNames: [String] = ["Drops", "Waves", "Forest", "Water in cave", "Rain and thunder", "White noise", "Fireplace"]
    private var currentTrackID: Int = 0
    private var channelID: String?
    private let userID: UInt = 2
    
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
        
        brightnessSlider.isHidden = true
        brightnessSlider.minimumValue = 0.1
        
        trackNameLabel.text = trackNames[currentTrackID]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        remoteView.frame = view.bounds
        
        showJoinAlert { channelID in
            self.channelID = channelID
            self.interactor?.makeRequest(request: .generateToken(channelID: "\(channelID)", role: .subscriber))
        }
        
        agoraKit?.enableAudio()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        agoraKit?.disableAudio()
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
        case .saveToken(token: let token):
            self.token = token
            self.joinAgoraChannel(channelID: channelID)
        case .showAlert(message: let message):
            showErrorAlert(with: message)
        }
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
        videoCanvas.uid = userID
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    private func joinAgoraChannel(channelID: String?) {
        guard
            let token = token,
            let channelID = channelID
        else { return }
        
        agoraKit?.joinChannel(byToken: token,
                              channelId: channelID,
                              info: nil,
                              uid: userID,
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

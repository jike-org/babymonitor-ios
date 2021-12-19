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
    
    @IBOutlet private weak var brightnessBtn: UIButton!
    @IBOutlet private weak var videoBtn: UIButton!
    @IBOutlet private weak var audioBtn: UIButton!
    @IBOutlet private weak var playPauseBtn: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
        
//        AVCaptureDevice.requestAccess(for: .video) { isGranted in
//            print(isGranted)
//        }
        
        remoteView = UIView()
        view.insertSubview(remoteView, at: 0)
        
        setupVideoCall()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showJoinAlert()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        remoteView.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    func displayData(viewModel: Player.Model.ViewModel.ViewModelData) {
    }
    
    private func showJoinAlert() {
        let alert = UIAlertController(title: "Connect to session", message: "Enter channel ID for connection to baby unit session", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = ""
        }
        
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
    }
    
    @IBAction private func videoPressed() {
        videoBtn.isSelected.toggle()
    }
    
    @IBAction private func audioPressed() {
        audioBtn.isSelected.toggle()
    }
    
    @IBAction private func playPausePressed() {
        playPauseBtn.isSelected.toggle()
    }
    
    @IBAction private func playPreviousTrack() {
        
    }
    
    @IBAction private func playNextTrack() {
        
    }
    
    @IBAction private func changeVolume(_ sender: UISlider) {
        
    }
    
    
}

// MARK: - Agora Rtc Engine Delegate

extension PlayerViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView

        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
}

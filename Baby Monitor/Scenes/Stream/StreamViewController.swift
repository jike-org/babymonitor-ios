//
//  StreamViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AgoraRtcKit

protocol StreamDisplayLogic: AnyObject {
    func displayData(viewModel: Stream.Model.ViewModel.ViewModelData)
}

class StreamViewController: UIViewController, StreamDisplayLogic {
    
    var interactor: StreamBusinessLogic?
    var router: (NSObjectProtocol & StreamRoutingLogic)?
    
    private var agoraKit: AgoraRtcEngineKit?
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
        setupVideoCall()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showInviteAlert()
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    private func setupVideoCall() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: Constants.appID, delegate: self)
        
        agoraKit?.enableVideo()
        agoraKit?.enableAudio()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        
        agoraKit?.setupLocalVideo(videoCanvas)
        
        agoraKit?.joinChannel(byToken: Constants.token,
                              channelId: "test",
                              info: nil,
                              uid: 0,
                              joinSuccess: nil)
    }
    
    private func showInviteAlert() {
        let ac = UIAlertController(title: "Connection info", message: "To connect a parent unit to this session, enter the code: \"test\" on the parent's device", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func displayData(viewModel: Stream.Model.ViewModel.ViewModelData) {
    }
    
    @IBAction private func dismissScene() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func flipCamera() {
    }
    
    @IBAction private func showConnectionInfo() {
        showInviteAlert()
    }
    
}

// MARK: - Agora Rtc Engine Delegate

extension StreamViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        activityIndicator.stopAnimating()
        infoLabel.text = "Connection is stable"
        infoLabel.textColor = .green
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        activityIndicator.startAnimating()
        infoLabel.text = "Waitinf for parent unit connection..."
        infoLabel.textColor = .black
    }
    
}


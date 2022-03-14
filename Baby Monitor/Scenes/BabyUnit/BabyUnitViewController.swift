//
//  BabyUnitViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 20.02.2022.
//

import UIKit
import AgoraRtcKit

class BabyUnitViewController: UIViewController {
    
    private var viewModel: BabyUnitViewModelType?
    private var agoraKit: AgoraRtcEngineKit?
    private var remoteView: UIView!
    private let currentUserID: UInt = 1
    private let isSub = UDService.shared.isSub()
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var saveBatteryStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BabyUnitViewModel()
        
        remoteView = UIView()
        view.insertSubview(remoteView, at: 0)
        
        view.backgroundColor = .beige
        setupVideoCall()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        saveBatteryStackView.isHidden = true
        
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        remoteView.frame = view.bounds
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
        
        let myLet = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        myLet.initialize(to: 1)
        let config = AgoraDataStreamConfig()
        agoraKit?.createDataStream(myLet, config: config)
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = currentUserID
        videoCanvas.renderMode = .hidden
        
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    @IBAction private func dismissScene() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func flipCamera() {
        viewModel?.switchCamera()
    }
    
    @IBAction private func showConnectionInfo() {
        showInviteAlert(channelID: viewModel!.channelID)
    }
    
}

// MARK: - Bind View Model

extension BabyUnitViewController {
    
    private func bindViewModel() {
        viewModel?.currentTrack.bind(listener: { (id, path) in
            self.agoraKit?.playEffect(id,
                                      filePath: path,
                                      loopCount: 1000,
                                      pitch: 1.0,
                                      pan: 0,
                                      gain: 100,
                                      publish: false,
                                      startPos: 0)
        })
        
        viewModel?.isVideoEnabled.bind { isEnable in
            self.saveBatteryStackView.isHidden = isEnable
            self.remoteView.isHidden = !isEnable
        }
        
        viewModel?.isAudioEnabled.bind { isEnable in
            let disable = self.agoraKit?.disableAudio()
            let enable = self.agoraKit?.enableAudio()
            isEnable ? disable : enable
        }
        
        viewModel?.isTrackPlaying.bind { (isPlaying, id) in
            let stop = self.agoraKit?.stopEffect(id)
            let resume = self.agoraKit?.resumeEffect(id)
            isPlaying ? stop : resume
        }
        
        viewModel?.currentCamera.bind { camera in
            self.agoraKit?.switchCamera()
            
            switch camera {
            case .front: break
            case .main: break
            }
        }
        
        viewModel?.createToken(completion: { token, channelID in
            self.showInviteAlert(channelID: channelID)
            self.agoraKit?.joinChannel(byToken: token,
                                       channelId: "\(channelID)",
                                       info: nil,
                                       uid: self.currentUserID,
                                       joinSuccess: nil)
        })
        
        viewModel?.preloadEffects(completion: { dict in
            dict.forEach { id, path in
                self.agoraKit?.preloadEffect(id, filePath: path)
            }
        })
        
        viewModel?.isSleep.bind(listener: { isSleep in
            guard isSleep else { return }
            self.saveBatteryStackView.isHidden = false
            self.remoteView.isHidden = false
            let value = Commands.setVideoDisable(value: true).description
            let data = Data(value.utf8)
            self.agoraKit?.sendStreamMessage(1, data: data)
        })
    }
    
}

// MARK: - Agora Rtc Engine Delegate

extension BabyUnitViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        activityIndicator.stopAnimating()
        infoLabel.text = "Connection is stable"
        infoLabel.textColor = .green
        
        let remoteCanvas = AgoraRtcVideoCanvas()
        remoteCanvas.uid = uid
        remoteCanvas.renderMode = .hidden
        remoteCanvas.view = remoteView
        
        agoraKit?.setupRemoteVideo(remoteCanvas)
        UIApplication.shared.isIdleTimerDisabled = true
        
        viewModel?.startSleepTimer()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        activityIndicator.startAnimating()
        infoLabel.text = "Waiting for parent unit connection..."
        infoLabel.textColor = .black
        viewModel?.stopPlayingTrack()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func rtcEngineDidAudioEffectFinish(_ engine: AgoraRtcEngineKit, soundId: Int) {
        viewModel?.playNextTrack()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        guard let string = String(data: data, encoding: .utf8) else { return }
        
        let myType = string.toCommandsEnum()
        
        switch myType {
        case .changeSound(value: let value):
            let res = Double(value * 100)
            agoraKit?.setEffectsVolume(res)
        case .changeBrightness(value: let value):
            viewModel?.changeBrightness(to: value)
        case .pauseSound:
            viewModel?.stopPlayingTrack()
        case .startSound:
            viewModel?.isPlayingStarted.value = true
            viewModel?.startPlayingTrack()
        case .nextTrack:
            if isSub {
                agoraKit?.stopAllEffects()
                viewModel?.playNextTrack()
            } else {
                onlyOneTrackAlert()
            }
        case .previousTrack:
            if isSub {
                agoraKit?.stopAllEffects()
                viewModel?.playPreviuosTrack()
            } else {
                onlyOneTrackAlert()
            }
        case .setVideoDisable(value: let value):
            viewModel?.isVideoEnabled.value = value
            if value {
                viewModel?.startSleepTimer()
            }
        default: break
        }
    }
    
}



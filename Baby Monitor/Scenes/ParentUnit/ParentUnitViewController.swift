//
//  ParentUnitViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 14.03.2022.
//

import UIKit
import AgoraRtcKit


class ParentUnitViewController: UIViewController {
    
    private lazy var viewModel: ParentUnitViewModelType = ParentUnitViewModel()
    private lazy var router: ParentUnitRoutingLogic = ParentUnitRouter()
    
    private var remoteView: UIView!
    private var token: String?
    private var localView: UIView!
    private var agoraKit: AgoraRtcEngineKit?
    private var trackNames: [String] = ["Drops", "Waves", "Forest", "Water in cave", "Rain and thunder", "White noise", "Fireplace"]
    private var currentTrackID: Int = 0
    private var channelID: String?
    private let userID: UInt = 2
    private let isSub = UDService.shared.isSub()
    
    @IBOutlet private weak var brightnessBtn: UIButton!
    @IBOutlet private weak var videoBtn: UIButton!
    @IBOutlet private weak var audioBtn: UIButton!
    @IBOutlet private weak var playPauseBtn: UIButton!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var remainingTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupVideoCall()
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
    
    
}

// MARK: - Bind View Model

extension ParentUnitViewController {
    
    private func bindViewModel() {
        viewModel.currentTrack.bind { name in
            self.trackNameLabel.text = name
        }
        
        viewModel.isTrial.bind { isTrial in
            self.remainingTime.isHidden = !isTrial
        }
        
        viewModel.remainingTime.bind { time in
            self.remainingTime.text = time
        }
    }
    
}

// MARK: - Agora Rtc Engine Delegate

extension ParentUnitViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView

        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        guard let string = String(data: data, encoding: .utf8) else { return }
        
        let myType = string.toCommandsEnum()!
        
        switch myType {
        case .setVideoDisable(_): videoBtn.isSelected = false
        default: break
        }
    }
    
}

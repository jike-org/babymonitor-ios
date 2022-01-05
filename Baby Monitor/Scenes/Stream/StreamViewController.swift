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
    private var remoteView: UIView!
    private var audioEffectsIDs: [Int32] = [0, 1, 2, 3, 4, 5, 6]
    private var audioEffectsFilePaths: [String] = []
//    private var audioEffectsFileIDs: [Int32] = []
    private var currentEffectID: Int32 = 1
    private var isStarted = false
    private var isMainCameraEnabled: Bool = false {
        didSet {
            toggleFlash()
        }
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var saveBatteryStackView: UIStackView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteView = UIView()
        view.insertSubview(remoteView, at: 0)
        
        view.backgroundColor = .beige
        setupVideoCall()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showInviteAlert()
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        let filePaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
        audioEffectsFilePaths.append(contentsOf: filePaths)
        
        for (path, id) in zip(audioEffectsFilePaths, audioEffectsIDs) {
            agoraKit?.preloadEffect(id, filePath: path)
        }
        
        saveBatteryStackView.isHidden = true
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        remoteView.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        
        for id in audioEffectsIDs {
            agoraKit?.unloadEffect(id)
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
    
    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        device.torchMode = AVCaptureDevice.TorchMode.on
//                        try device.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    private func changeTorchLevel(value: Float) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        try? device.lockForConfiguration()
        if (device.hasTorch) {
            try? device.setTorchModeOn(level: value)
        }
        device.unlockForConfiguration()
    }
    
    func displayData(viewModel: Stream.Model.ViewModel.ViewModelData) {
    }
    
    @IBAction private func dismissScene() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func flipCamera() {
        agoraKit?.switchCamera()
        isMainCameraEnabled.toggle()
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
        
        let remoteCanvas = AgoraRtcVideoCanvas()
        remoteCanvas.uid = uid
        remoteCanvas.renderMode = .hidden
        remoteCanvas.view = remoteView
        
        agoraKit?.setupRemoteVideo(remoteCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        activityIndicator.startAnimating()
        infoLabel.text = "Waiting for parent unit connection..."
        infoLabel.textColor = .black
        agoraKit?.stopAllEffects()
    }
    
    func rtcEngineDidAudioEffectFinish(_ engine: AgoraRtcEngineKit, soundId: Int) {
        if currentEffectID == 0 {
            currentEffectID = 6
        } else {
            currentEffectID -= 1
        }
        agoraKit?.playEffect(currentEffectID,
                             filePath: audioEffectsFilePaths[Int(currentEffectID)],
                             loopCount: 1,
                             pitch: 1.0,
                             pan: 0,
                             gain: 100,
                             publish: false,
                             startPos: 0)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        guard let string = String(data: data, encoding: .utf8) else { return }
        
        let myType = string.toCommandsEnum()
        
        switch myType {
        case .changeSound(value: let value):
            let res = Double(value * 100)
            agoraKit?.setEffectsVolume(res)
        case .changeBrightness(value: let value):
            if isMainCameraEnabled {
                changeTorchLevel(value: value)
            } else {
                UIScreen.main.brightness = CGFloat(value)
            }
        case .pauseSound:
            agoraKit?.pauseEffect(currentEffectID)
        case .startSound:
            if isStarted {
                agoraKit?.resumeEffect(currentEffectID)
            } else {
                isStarted = true
                agoraKit?.playEffect(currentEffectID,
                                     filePath: audioEffectsFilePaths[Int(currentEffectID)],
                                     loopCount: 1,
                                     pitch: 1.0,
                                     pan: 0,
                                     gain: 100,
                                     publish: false,
                                     startPos: 0)
            }
        case .nextTrack:
            agoraKit?.stopEffect(currentEffectID)
            if currentEffectID == 6 {
                currentEffectID = 0
            } else {
                currentEffectID += 1
            }
            agoraKit?.playEffect(currentEffectID,
                                 filePath: audioEffectsFilePaths[Int(currentEffectID)],
                                 loopCount: 1,
                                 pitch: 1.0,
                                 pan: 0,
                                 gain: 100,
                                 publish: false,
                                 startPos: 0)
        case .previousTrack:
            agoraKit?.stopEffect(currentEffectID)
            if currentEffectID == 0 {
                currentEffectID = 6
            } else {
                currentEffectID -= 1
            }
            agoraKit?.playEffect(currentEffectID,
                                 filePath: audioEffectsFilePaths[Int(currentEffectID)],
                                 loopCount: 1,
                                 pitch: 1.0,
                                 pan: 0,
                                 gain: 100,
                                 publish: false,
                                 startPos: 0)
        case .setVideoDisable(value: let value):
            saveBatteryStackView.isHidden = value
            remoteView.isHidden = !value
        default:
            break
        }
    }
    
}


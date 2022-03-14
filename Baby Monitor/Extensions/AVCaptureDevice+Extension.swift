//
//  AVCaptureDevice+Extension.swift
//  Baby Monitor
//
//  Created by Andreas on 20.02.2022.
//

import AVFoundation

extension AVCaptureDevice {
    
    static func toggleFlash() {
        guard let device = self.default(for: AVMediaType.video) else { return }
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    device.torchMode = AVCaptureDevice.TorchMode.on
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    static func changeTorchLevel(value: Float) {
        guard let device = self.default(for: AVMediaType.video) else { return }
        try? device.lockForConfiguration()
        if (device.hasTorch) {
            try? device.setTorchModeOn(level: value)
        }
        device.unlockForConfiguration()
    }
    
}

//
//  Commands.swift
//  Baby Monitor
//
//  Created by Andreas on 24.12.2021.
//

import Foundation

enum Commands {
    case pauseSound
    case startSound
    case nextTrack
    case previousTrack
    case changeBrightness(value: Float)
    case changeSound(value: Float)
    case setVideoDisable(value: Bool)
}

extension Commands {
    var description: String {
        switch self {
        case .pauseSound:
            return "pauseSound"
        case .startSound:
            return "startSound"
        case .nextTrack:
            return "nextTrack"
        case .previousTrack:
            return "previousTrack"
        case .changeSound(value: let value):
            return "changeSound:\(value)"
        case .changeBrightness(value: let value):
            return "changeBrightness:\(value)"
        case .setVideoDisable(value: let value):
            return "setVideoDisable:\(value)"
        }
    }
}

extension String {
    
    func toCommandsEnum() -> Commands? {
        guard
            let first = self.split(separator: ":").first
        else { return nil }
        
        switch first {
        case "changeBrightness":
            let value = self.split(separator: ":")[1]
            guard let res = Float(value) else { return nil }
            return .changeBrightness(value: res)
        case "pauseSound":
            return .pauseSound
        case "startSound":
            return .startSound
        case "nextTrack":
            return .nextTrack
        case "previousTrack":
            return .previousTrack
        case "changeSound":
            let value = self.split(separator: ":")[1]
            guard let res = Float(value) else { return nil }
            return .changeSound(value: res)
        case "setVideoDisable":
            let value = self.split(separator: ":")[1]
            guard let res = Bool(String(value)) else { return nil }
            return .setVideoDisable(value: res)
        default:
            return nil
        }
    }
    
}

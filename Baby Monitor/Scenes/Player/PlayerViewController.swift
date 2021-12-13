//
//  PlayerViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PlayerDisplayLogic: AnyObject {
    func displayData(viewModel: Player.Model.ViewModel.ViewModelData)
}

class PlayerViewController: UIViewController, PlayerDisplayLogic {
    
    var interactor: PlayerBusinessLogic?
    var router: (NSObjectProtocol & PlayerRoutingLogic)?
    
    @IBOutlet private weak var brightnessBtn: UIButton!
    @IBOutlet private weak var videoBtn: UIButton!
    @IBOutlet private weak var audioBtn: UIButton!
    @IBOutlet private weak var playPauseBtn: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
    }
    
    func displayData(viewModel: Player.Model.ViewModel.ViewModelData) {
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

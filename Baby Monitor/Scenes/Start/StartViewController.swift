//
//  StartViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol StartDisplayLogic: AnyObject {
    func displayData(viewModel: Start.Model.ViewModel.ViewModelData)
}

class StartViewController: UIViewController, StartDisplayLogic {
    
    var interactor: StartBusinessLogic?
    var router: (NSObjectProtocol & StartRoutingLogic)?
    
    private var peerID: MCPeerID!
    private var mcSession: MCSession!
    private var sessionAssistant: MCAdvertiserAssistant!
    private var selectedButton: UnitSelection?
    private var browserVC: MCBrowserViewController!
    private var activityController: UIActivityViewController?
    
    @IBOutlet private weak var firstTitle: UILabel!
    @IBOutlet private weak var chooseAccount: UILabel!
    @IBOutlet private weak var babyBtn: UIButton!
    @IBOutlet private weak var parentBtn: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: .none, encryptionPreference: .required)
        browserVC = MCBrowserViewController(serviceType: "service", session: mcSession)
        
        mcSession.delegate = self
        browserVC.delegate = self
        
        view.backgroundColor = .lightPurple
        firstTitle.textColor = .customDartGray
        chooseAccount.textColor = .customDartGray
        
    }
    
    func displayData(viewModel: Start.Model.ViewModel.ViewModelData) {
    }
    
    @IBAction private func toBabyUnit() {
        router?.navigateToBabyScene()
    }
    
    @IBAction private func toParentUnit() {
        router?.navigateToPlayerScene()
    }
    
    @IBAction private func shareApp() {
        let text = ["Text to share"]
        activityController = UIActivityViewController(activityItems: text, applicationActivities: nil)
        activityController?.popoverPresentationController?.sourceView = view
        guard let activityController = activityController else { return }
        present(activityController, animated: true, completion: nil)
    }
    
}

extension StartViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
//        browserVC.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
        router?.navigateToPlayerScene()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension StartViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
}



//
//  StreamViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol StreamDisplayLogic: AnyObject {
    func displayData(viewModel: Stream.Model.ViewModel.ViewModelData)
}

class StreamViewController: UIViewController, StreamDisplayLogic {
    
    var interactor: StreamBusinessLogic?
    var router: (NSObjectProtocol & StreamRoutingLogic)?
    
    private var peerID: MCPeerID!
    private var session: MCSession!
    private var sessionAssitant: MCAdvertiserAssistant!
    
    private var nearbyAdvertiser: MCNearbyServiceAdvertiser!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .beige
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: .none, encryptionPreference: .required)
        session.delegate = self
        startHosting()
    }
    
    func displayData(viewModel: Stream.Model.ViewModel.ViewModelData) {
    }
    
    private func startHosting() {
//        sessionAssitant = MCAdvertiserAssistant(serviceType: "test", discoveryInfo: .none, session: session)
////        sessionAssitant.delegate = self
//        sessionAssitant.start()
//
        nearbyAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: .none, serviceType: "service")
        nearbyAdvertiser.delegate = self
        nearbyAdvertiser.startAdvertisingPeer()
    }
    
    @IBAction private func dismissScene() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func flipCamera() {
    }
    
}

extension StreamViewController: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let title = "Accept \(peerID.displayName)"
        let message = "Would you like to accept: \(peerID.displayName)"
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No",
                                                style: .cancel) { _ in
            invitationHandler(false, nil)
        })
        
        alertController.addAction(UIAlertAction(title: "Yes",
                                                style: .default) { _ in
            invitationHandler(true, self.session)
        })
        present(alertController, animated: true)
    }
    
    
}

extension StreamViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(state.rawValue)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(peerID)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(peerID)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(peerID)
    }
    
}

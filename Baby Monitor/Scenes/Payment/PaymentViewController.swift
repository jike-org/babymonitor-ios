//
//  PaymentViewController.swift
//  Baby Monitor
//
//  Created by Andreas on 03.12.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PaymentDisplayLogic: AnyObject {
    func displayData(viewModel: Payment.Model.ViewModel.ViewModelData)
}

class PaymentViewController: UIViewController, PaymentDisplayLogic {
    
    var interactor: PaymentBusinessLogic?
    var router: (NSObjectProtocol & PaymentRoutingLogic)?
    
    private var previousIndexPath: IndexPath!
    private var headerCell: HeaderCell?
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        view.backgroundColor = .lightPurple
        
        interactor?.makeRequest(request: .checkTrialAvalabilty)
    }
    
    private func setupTableView() {
        let nibCell = UINib(nibName: "PaymentCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: PaymentCell.reuseID)
        
        let headerNib = UINib(nibName: "HeaderCell", bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: HeaderCell.reuseID)
        
        let footerNib = UINib(nibName: "PaymentFooterCell", bundle: nil)
        tableView.register(footerNib, forCellReuseIdentifier: PaymentFooterCell.reuseID)
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func displayData(viewModel: Payment.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTimer(let time):
            headerCell?.setTimer(time: time)
        }
    }
    
    @IBAction private func continueTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UI Table View Delegate & Data Source

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseID) as! HeaderCell
        headerCell = cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {    220
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCell.reuseID, for: indexPath) as! PaymentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentFooterCell.reuseID) as! PaymentFooterCell
        
        cell.privacyPoliceCB = { [weak self] in
            guard let self = self else { return }
            self.router?.navigateToLegals()
        }
        
        cell.termOfUseCB = { [weak self] in
            guard let self = self else { return }
            self.router?.navigateToLegals()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        912
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PaymentCell else { return }
        cell.toggleSelection()
    }
    
}

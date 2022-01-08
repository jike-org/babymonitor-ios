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
    private var viewModel = PaymentViewModel.init(tariffs: [])
    private var selectedIndexPath: IndexPath?
    
    private var tableView: UITableView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        view.backgroundColor = .lightPurple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor?.makeRequest(request: .checkTrialAvalabilty)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView?.separatorStyle = .none
        view.addSubview(tableView!)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView!.topAnchor.constraint(equalTo: view.topAnchor),
            tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let nibCell = UINib(nibName: "PaymentCell", bundle: nil)
        tableView?.register(nibCell, forCellReuseIdentifier: PaymentCell.reuseID)
        
        let headerNib = UINib(nibName: "HeaderCell", bundle: nil)
        tableView?.register(headerNib, forCellReuseIdentifier: HeaderCell.reuseID)
        
        let footerNib = UINib(nibName: "PaymentFooterCell", bundle: nil)
        tableView?.register(footerNib, forCellReuseIdentifier: PaymentFooterCell.reuseID)
        
        tableView?.tableFooterView = UIView()
        
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func displayData(viewModel: Payment.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTimer(let time):
            headerCell?.setTimer(time: time)
        case .displayTariffs(viewModel: let viewModel):
            self.viewModel = viewModel
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        case .displatAlert(message: let message):
            showErrorAlert(with: message)
        case .displayBuySuccess:
            showAlert(with: "Thanks for payment!", completion: {})
            guard
                let indexPath = selectedIndexPath,
                let cell = tableView?.cellForRow(at: indexPath) as? PaymentCell
            else { return }
            cell.hideProgress()
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    private func continueTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UI Table View Delegate & Data Source

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseID) as? HeaderCell
        else { return nil }
        headerCell = cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        220
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tariffs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCell.reuseID, for: indexPath) as? PaymentCell
        else { return UITableViewCell() }
        
        let viewModel = viewModel.tariffs[indexPath.row]
        cell.apply(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentFooterCell.reuseID) as? PaymentFooterCell
        else { return nil }
        
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
        guard let cell = tableView.cellForRow(at: indexPath) as? PaymentCell
        else { return }
        cell.showPogress()
        selectedIndexPath = indexPath
        let id = viewModel.tariffs[indexPath.row].tariffID
        interactor?.makeRequest(request: .selectTariff(id: id))
    }
    
}

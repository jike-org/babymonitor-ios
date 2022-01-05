//
//  IAPService.swift
//  Baby Monitor
//
//  Created by Andreas on 30.12.2021.
//

import Foundation
import StoreKit

protocol IAPServiceDelegate: AnyObject {
    func productsFetched(_ products: [SKProduct])
    func onTransactionFailed(_ error: Error)
    func onTransactionSuccess()
    func onTransactionResctored()
}

class IAPService: NSObject {
    
    static let shared = IAPService()
    private override init() { }
    
    weak var delegate: IAPServiceDelegate?
    var producsts: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    func setupPurchases(completion: @escaping (Bool) -> Void) {
        if SKPaymentQueue.canMakePayments() {
            paymentQueue.add(self)
            completion(true)
            return
        }
        completion(false)
    }

    func fetchProducts() {
        let ids: Set = [
            IAPProducts.lifetime.rawValue,
            IAPProducts.weekly.rawValue,
            IAPProducts.monthly.rawValue
        ]
        
        let req = SKProductsRequest(productIdentifiers: ids)
        req.delegate = self
        req.start()
    }
    
    func purchase(productWith identifier: String?) {
        guard
            let identifier = identifier,
            let product = producsts.first(where: { $0.productIdentifier == identifier })
        else { return }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
        
    }
    
    func restoreCompletedTransaction() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    
}

// MARK: - SK Payment Transaction Observer

extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: break
            case .purchasing: break
            case .failed: failed(transaction: transaction)
            case .purchased: completed(transaction: transaction)
            case .restored: restored(transaction: transaction)
            @unknown default: break
            }
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Error ", transactionError)
            }
        }
        delegate?.onTransactionFailed(transaction.error!)
        paymentQueue.finishTransaction(transaction)
    }
    
    private func completed(transaction: SKPaymentTransaction) {

        paymentQueue.finishTransaction(transaction)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
    }
    
    
}

// MARK: - SK Products Request Delegate

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        producsts = response.products
        delegate?.productsFetched(response.products)
    }
    
    
}

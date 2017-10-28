//
//  CustomTabBarController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private enum Constants {
        static let seguePayment = "payment"
        static let segueRecurring = "recurring"
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.openMessages {
            selectedIndex = 0
        } else {
            selectedIndex = 2
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(actOnMessagesPush), name: Notification.Name("message"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actOnPaymentPush(amount:)), name: Notification.Name("payment"), object: nil)
    }
    
    @objc private func actOnPaymentPush(amount: Int) {
        presentPayment(amount: amount)
    }
    
    @objc private func actOnMessagesPush() {
        tabBar.items![0].badgeValue = "!"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let amount = appDelegate.paymentAmount {
            presentPayment(amount: amount)
            appDelegate.paymentAmount = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let id = segue.identifier else { return }
        
        switch id {
        case Constants.seguePayment:
            let vc = segue.destination as! PaymentViewController
            vc.amount.value = sender as! Int
        default:
            break
        }
    }
    
    func presentPayment(amount: Int = 5) {
        performSegue(withIdentifier: Constants.seguePayment, sender: amount)
    }
    
    func presentRecurring(journey: Journey? = nil) {
        performSegue(withIdentifier: Constants.segueRecurring, sender: journey)
    }
    
}

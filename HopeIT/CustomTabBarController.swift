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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let id = segue.identifier else { return }
        
        switch id {
        case Constants.seguePayment:
            let vc = segue.destination as! PaymentViewController
            vc.amount.value = sender as! Int
//        case Constants.segueRecurring:
//            let vc = (segue.destination as! UINavigationController).viewControllers.first as! JourneysViewController
//            vc.journey = sender as? Journey
        default:
            break
        }
    }
    
    func presentPayment(amount: Int = 10) {
        performSegue(withIdentifier: Constants.seguePayment, sender: amount)
    }
    
    func presentRecurring(journey: Journey? = nil) {
        performSegue(withIdentifier: Constants.segueRecurring, sender: journey)
    }
    
}

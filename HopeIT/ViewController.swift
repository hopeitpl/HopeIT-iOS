//
//  ViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private enum Constants {
        static let segueTabBar = "toTab"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.performAfter(delay: 2.0) { [unowned self] in
            self.performSegue(withIdentifier: Constants.segueTabBar, sender: nil)
        }
    }

}


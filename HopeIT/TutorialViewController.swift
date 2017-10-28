//
//  TutorialViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
}

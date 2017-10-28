//
//  MessageViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var message: Message!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = message.content
        imageView.image = message.picture ?? UIImage(named: "ziemia")
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

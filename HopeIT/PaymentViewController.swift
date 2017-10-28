//
//  PaymentViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import RxSwift

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    let amount = Variable(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setReactiveBindings()
        
    }
    
    private func setReactiveBindings() {
        
        amount.asObservable()
            .map { "\($0)" }
            .bind(to: amountField.rx.text)
            .addDisposableTo(disposeBag)
        
        amountField.rx.text
            .orEmpty
            .subscribe(
                onNext: { [unowned self] text in
                    let active = Int(text) != nil
                    self.submitButton.isEnabled = active
                    self.submitButton.backgroundColor = active ? UIColor.defaultPink() : UIColor.darkGray
                }
            )
            .addDisposableTo(disposeBag)
        
        closeButton.rx.tap
            .subscribe(
                onNext: { [unowned self] _ in
                    self.dismiss(animated: true)
                }
            )
            .addDisposableTo(disposeBag)
        
        submitButton.rx.tap
            .subscribe(
                onNext: { [unowned self] _ in
                    self.proceed()
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    private func proceed() {
        
    }
}

extension PaymentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

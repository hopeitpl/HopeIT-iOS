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
    
    private let viewModel = PaymentViewModel()
    private let disposeBag = DisposeBag()
    
    let amount = Variable(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setReactiveBindings()
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeKeyboard))]
        numberToolbar.sizeToFit()
        amountField.inputAccessoryView = numberToolbar
        
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
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
        
        viewModel.url.asObservable().subscribe(onNext: {
            guard let urlString = $0, let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }).addDisposableTo(disposeBag)
    }
    
    private func proceed() {
        viewModel.post(amount: Int(amountField.text!)!)
    }
}

extension PaymentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

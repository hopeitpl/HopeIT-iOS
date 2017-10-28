//
//  JourneyConfiguratorViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import PKHUD

class JourneyConfiguratorViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var intervalSwitch: UISwitch!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    let journey = Variable<Journey?>(nil)
    private let disposeBag = DisposeBag()
    private let viewModel = JourneyConfiguratorViewModel()
    
    @IBAction func didTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReactiveBindings()
    }
    
    
    private func setReactiveBindings() {
        journey.asObservable().subscribe(onNext: { [unowned self] in
            guard let journey = $0 else { return }
            self.durationSlider.setValue(Float(journey.installments), animated: false)
            self.durationLabel.text = "\(journey.installments)"
            self.intervalSwitch.setOn(journey.notificationInterval == NotificationInterval.month, animated: false)
            self.valueSlider.setValue(Float(journey.value), animated: false)
            self.valueLabel.text = "\(journey.value)"
        }).addDisposableTo(disposeBag)
        
        durationSlider.rx.value.subscribe(onNext: { [unowned self] in
            print($0)
            self.viewModel.duration.value = Int($0)
            self.durationLabel.text = "\(Int($0))"
        }).addDisposableTo(disposeBag)
        
        valueSlider.rx.value.subscribe(onNext: { [unowned self] in
            print($0)
            self.viewModel.value.value = Int($0)
            self.valueLabel.text = "\(Int($0))"
        }).addDisposableTo(disposeBag)
        
        submitButton.rx.tap
            .bind { [unowned self] in
                self.post()
            }
            .addDisposableTo(disposeBag)
    }
    
    private func post() {
        let url = "http://10.99.130.92:8000/users/1/goal/"
        let params: Parameters = ["user_id": 1, "target": self.viewModel.value.value, "months": self.viewModel.duration.value, "notify_freq": self.intervalSwitch.isOn ? 7 : 30]
        Alamofire.request(url, method: .post, parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                self.navigationController?.dismiss(animated: true, completion: {
                    HUD.flash(.success, delay: 1.0)
                })
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        }
    }
    
}

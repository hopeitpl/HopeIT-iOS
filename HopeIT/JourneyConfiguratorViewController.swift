//
//  JourneyConfiguratorViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import RxSwift

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
                print(self.viewModel.duration.value)
                print(self.viewModel.value.value)
                print(self.intervalSwitch.isOn ? "\(NotificationInterval.month)" : "\(NotificationInterval.week)")
            }
            .addDisposableTo(disposeBag)
    }
    
}

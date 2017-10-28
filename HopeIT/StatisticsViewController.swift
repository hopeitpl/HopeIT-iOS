//
//  StatisticsViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//
import UIKit
import RxSwift

class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticsViewModel()
    
    @IBOutlet weak var totalTransfersLabel: UILabel!
    @IBOutlet weak var totalGoalsLAbel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientLayer()
        bindReactive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getStatistics()
    }
    
    private func bindReactive() {
        
        viewModel.finishedGoals.asObservable().map { "\($0)" }.bind(to: totalGoalsLAbel.rx.text).addDisposableTo(disposeBag)
        viewModel.totalAmount.asObservable().map { "\($0) PLN" }.bind(to: totalAmountLabel.rx.text).addDisposableTo(disposeBag)
        viewModel.totalPayments.asObservable().map { "\($0)" }.bind(to: totalTransfersLabel.rx.text).addDisposableTo(disposeBag)
        
    }
    
}

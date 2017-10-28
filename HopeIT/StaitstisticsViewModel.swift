//
//  StaitstisticsViewModel.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import RxSwift
import Alamofire
import PKHUD

struct StatisticsViewModel {
    
    //total_amount, total_payments, finished_goals
    
    let totalAmount = Variable(0)
    let totalPayments = Variable(0)
    let finishedGoals = Variable(0)
    
    func getStatistics() {
        let url = "http://\(URLs.apiPrefix)/users/1/stats"
        HUD.show(.progress)
        Alamofire.request(url).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                if let JSON = response.result.value as? [String: Int] {
                    self.totalAmount.value = JSON["total_amount"] ?? 0
                    self.totalPayments.value = JSON["total_payments"] ?? 0
                    self.finishedGoals.value = JSON["finished_goals"] ?? 0
                }
            }
            HUD.hide()
        }
    }
    
}

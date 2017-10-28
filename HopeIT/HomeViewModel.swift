//
//  HomeViewModel.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import RxSwift
import Alamofire

struct HomeViewModel {
    
    let target = Variable<Int?>(nil)
    let balance = Variable<Int?>(nil)
    
    func fetchHomeScreen() {
        let url = "http://10.99.130.92:8000/users/1/goal"
        Alamofire.request(url).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                if let JSON = response.result.value as? [String: AnyObject] {
                    if let target = JSON["target"] as? Int, let balance = JSON["balance"] as? Int {
                        self.target.value = target
                        self.balance.value = balance
                    }
                }
            }
        }
    }
    
}

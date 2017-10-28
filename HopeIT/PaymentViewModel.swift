//
//  PaymentViewModel.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 28.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import Alamofire
import RxSwift
import PKHUD

struct PaymentViewModel {
    
    let url = Variable<String?>(nil)
    
    func post(amount: Int, description: String = "user:1") {
        let url = "http://\(URLs.apiPrefix)/payments/"
        let params: Parameters = ["amount": amount, "description": description]
        Alamofire.request(url, method: .post, parameters: params,
                          encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            if response.result.isSuccess, Utilities.isStatusValid(code: response.response?.statusCode) {
                if let JSON = response.result.value as? [String: String], let url = JSON["results"] {
                    self.url.value = url
                    return
                }
            }
            HUD.flash(.error, delay: 1.0)
        }
    }
    
}

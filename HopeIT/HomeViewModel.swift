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
    
    let progress = Variable<Double>(0.0)
    let target = Variable<Int?>(nil)
    let balance = Variable<Int>(0)
    let errorString = Variable<String>("")
    
    func fetchHomeScreen() {
        guard let url = URL(string: "") else {
            return
        }
        Alamofire.request(url).responseJSON { response in
            
        }
    }
    
}

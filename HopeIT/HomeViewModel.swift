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
    
    private let user: User
    
    let progress = Variable<Double>(0.0)
    let target = Variable<Int?>(nil)
    let balance = Variable<Int>(0)
    let errorString = Variable<String>("")
    
    init(user: User) {
        self.user = user
    }
    
    func fetchHomeScreen() {
        guard let url = URL(string: "") else {
            return
        }
        Alamofire.request(url).responseJSON { response in
            
        }
    }
    
}

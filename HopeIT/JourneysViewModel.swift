//
//  JourneysViewModel.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import RxSwift

struct JourneysViewModel {
    
    let journeys = Variable<[Journey]>([])
    
    init() {
        journeys.value = generateJourneys()
    }
    
    private func generateJourneys() -> [Journey] {
        let mars = Journey(name: "Misja na Marsa",
                           desc: "100 złotych w 3 miesiące", installments: 3,
                           value: 100,
                           notificationInterval: .week,
                           imageName: "mars",
                           tintColor: UIColor.marsOrange())
        
        let saturn = Journey(name: "Pierscienie Saturna",
                              desc: "500 złotych w poł roku", installments: 6,
                              value: 500,
                              notificationInterval: .month,
                              imageName: "saturn",
                              tintColor: UIColor.saturn())
        
        let stars = Journey(name: "Dzienniki gwiazdowe",
                             desc: "1500 złotych w rok", installments: 12,
                             value: 1500,
                             notificationInterval: .month,
                             imageName: "gwiazdy",
                             tintColor: UIColor.defaultBlue())
        return [mars, saturn, stars]
    }
}

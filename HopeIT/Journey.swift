//
//  Journey.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import Foundation

enum NotificationInterval {
    case month
    case week
}

struct Journey {
    
    let name: String
    let desc: String
    let installments: Int
    let value: Int
    let notificationInterval: NotificationInterval

}

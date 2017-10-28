//
//  Utilities.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import Foundation

class Utilities {
    
    static func performAfter(delay: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
    
    static func isStatusValid(code: Int?) -> Bool {
        if let code = code {
            if !(code >= 200 && code < 300) {
                print("ERROR CODE \(code)")
            }
            return code >= 200 && code < 300
        }
        return false
    }
    
}

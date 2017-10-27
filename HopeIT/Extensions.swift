//
//  Extensions.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static func defaultBlue() -> UIColor {
        return UIColor(hex: "084e94")
    }
    
    static func lightBlue() -> UIColor {
        return UIColor(hex: "27c3f2")
    }
    
    static func defaultPink() -> UIColor {
        return UIColor(hex: "c41b4b")
    }
    
    static func defaultGrey() -> UIColor {
        return UIColor(hex: "ecf0f5")
    }
}

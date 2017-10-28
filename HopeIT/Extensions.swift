//
//  Extensions.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func applyGradientLayer() {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.defaultBlue().cgColor, UIColor.lightBlue().cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds =  false
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }
}

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
    
    static func marsOrange() -> UIColor {
        return UIColor(hex: "F17411")
    }
    
    static func saturn() -> UIColor {
        return UIColor(hex: "FFEA7C")
    }

}

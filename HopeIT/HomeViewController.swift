//
//  HomeViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import RxGesture

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var saturn: UIImageView!
    @IBOutlet weak var earth: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    private enum Constants {
        static let earthAnimKey = "earthAnim"
        static let saturnMoveKey = "saturnAnim"
        static let logoAnimKey = "logoAnim"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saturn.layer.removeAllAnimations()
    }

    // MARK: UI Customization
    
    private func initAnimations() {
        scale(view: logo, with: Constants.logoAnimKey, duration: 0.5)
        rotate(view: earth, with: Constants.earthAnimKey, duration: 100.0)
        move(view: saturn, for: 150, with: Constants.saturnMoveKey, duration: 15.0)
    }
    
    private func applyGradientLayer() {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.defaultBlue().cgColor, UIColor.lightBlue().cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func move(view: UIView, for value: CGFloat, with key: String, duration: Double = 1) {
        if view.layer.animation(forKey: key) == nil {
            let movementAnimation = CABasicAnimation(keyPath: "position")
            
            movementAnimation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y))
            movementAnimation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + value, y: view.center.y))
            movementAnimation.duration = duration
            movementAnimation.repeatCount = Float.infinity
            movementAnimation.autoreverses = true
            movementAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            view.layer.add(movementAnimation, forKey: key)
        }
    }

    private func scale(view: UIView, with key: String, duration: Double = 1) {
        if view.layer.animation(forKey: key) == nil {
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.1
            scaleAnimation.duration = duration
            scaleAnimation.repeatCount = Float.infinity
            scaleAnimation.autoreverses = true
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            view.layer.add(scaleAnimation, forKey: key)
        }
    }

    
    private func rotate(view: UIView, with key: String, duration: Double = 1) {
        if view.layer.animation(forKey: key) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(Double.pi * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            view.layer.add(rotationAnimation, forKey: key)
        }
    }
    
}


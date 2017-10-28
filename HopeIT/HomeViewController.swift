//
//  HomeViewController.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var widgetView: UIView!

    @IBOutlet weak var mars: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var saturn: UIImageView!
    @IBOutlet weak var earth: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var recurringButton: UIButton!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addPaymentView: UIView!
    
    private let homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private enum Constants {
        static let earthAnimKey = "earthAnim"
        static let saturnMoveKey = "saturnAnim"
        static let logoAnimKey = "logoAnim"
        static let marsAnimKey = "marsAnim"
        static let marsRotateKey = "marsRotateAnim"
        static let marsMoveKey = "marsMoveKey"
        static let buttonAnimKey = "buttonAnim"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setReactiveBinding()
        setUI()
        applyGradientLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("payment_confirm"), object: nil)
    }
    
    @objc private func refresh() {
        homeViewModel.fetchHomeScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initAnimations()
        homeViewModel.fetchHomeScreen()
    }

    private func setReactiveBinding() {
        closeButton.rx.tap
            .bind { [unowned self] in self.hideOverlay() }
            .addDisposableTo(disposeBag)
        
        recurringButton.rx.tap
            .bind { [unowned self] in self.recurringAction() }
            .addDisposableTo(disposeBag)
        
        paymentButton.rx.tap
            .bind { [unowned self] in self.paymentAction() }
            .addDisposableTo(disposeBag)

        addPaymentView.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.showOverlay()
        }).addDisposableTo(disposeBag)
        
        homeViewModel.balance.asObservable().subscribe(onNext: { [unowned self] in
            guard let balance = $0 else {
                return
            }
            self.balanceLabel.text = "\(balance) PLN"
            guard let target = self.homeViewModel.target.value else { return }
            let progress = Float(balance) / Float(target)
            self.progressBar.setProgress(progress, animated: false)
        }).addDisposableTo(disposeBag)
        
        homeViewModel.target.asObservable().subscribe(onNext: { [unowned self] in
            guard let target = $0 else {
                self.widgetView.isHidden = true
                return
            }
            self.topLabel.text = "\(target) PLN"
            self.widgetView.isHidden = false
        }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: Actions
    
    private func recurringAction() {
        hideOverlay()
        (tabBarController as? CustomTabBarController)?.presentRecurring()
    }
    
    private func paymentAction() {
        hideOverlay()
        (tabBarController as? CustomTabBarController)?.presentPayment()
    }
    
    // MARK: UI Customization
    
    private func hideOverlay() {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.overlayView.alpha = 0.0
        }, completion: { [unowned self] _ in
            self.overlayView.isUserInteractionEnabled = false
        })
    }
    
    private func showOverlay() {
        view.bringSubview(toFront: overlayView)
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.overlayView.alpha = 1.0
            }, completion: { [unowned self] _ in
                self.overlayView.isUserInteractionEnabled = true
        })
    }
    
    private func setUI() {
        widgetView.layer.cornerRadius = 20.0
        widgetView.clipsToBounds = true
        widgetView.dropShadow()
        logo.dropShadow()
        addPaymentView.layer.cornerRadius = 30.0
        addPaymentView.clipsToBounds = true
        addPaymentView.dropShadow()
        paymentButton.setTitleColor(UIColor.defaultPink(), for: .normal)
        recurringButton.setTitleColor(UIColor.defaultPink(), for: .normal)
    }
    
    private func initAnimations() {
        scale(view: mars, with: Constants.marsAnimKey, duration: 2.0)
        move(view: mars, for: -100, with: Constants.marsMoveKey, duration: 20)
        rotate(view: mars, with: Constants.marsRotateKey, duration: 30)
        scale(view: addPaymentView, with: Constants.buttonAnimKey, duration: 0.5)
        scale(view: logo, with: Constants.logoAnimKey, duration: 0.5)
        rotate(view: earth, with: Constants.earthAnimKey, duration: 100.0)
        move(view: saturn, for: 150, with: Constants.saturnMoveKey, duration: 15.0)
    }
    
    private func move(view: UIView, for value: CGFloat, with key: String, duration: Double = 1) {
        if view.layer.animation(forKey: key) == nil {
            let movementAnimation = CABasicAnimation(keyPath: "position")
            
            movementAnimation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y))
            movementAnimation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x - value, y: view.center.y))
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


//
//  AppDelegate.swift
//  HopeIT
//
//  Created by Piotr Olejnik on 27.10.2017.
//  Copyright © 2017 bydlaki. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import BRYXBanner

    /*
    Push notification handling needs heavy reimplementation (eg. including authorization stuff)
    */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    private var paymentAmount: Int?
    private var openMessages = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        applyInitialAppearance()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })

        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        if (launchOptions != nil), let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            if let _ = remoteNotification["type"] as? String {
                openMessages = true
            }
        }
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) { }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) { }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        let userInfo = notification.request.content.userInfo
        var amount: Int? = nil
        if let a = (userInfo["aps"] as? [String: AnyObject])?["alert"] as? String, let int = Int(a) {
            amount = int
        }
        action(on: userInfo["type"] as! String, amount: amount)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let userInfo = response.notification.request.content.userInfo
        var amount: Int? = nil
        
        if let a = (userInfo["aps"] as? [String: AnyObject])?["alert"] as? String, let int = Int(a) {
            amount = int
        }
        action(on: userInfo["type"] as! String, amount: amount)
    }

    // MARK: Private
    
    private func applyInitialAppearance() {
        UITabBar.appearance().tintColor = UIColor.defaultBlue()
        UITabBar.appearance().shadowImage = UIImage()
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = UIColor.white

    }
    
    private func action(on type: String, amount: Int?) {
        var content = "Otrzymano nową wiadomość"
        if type == "" {
            content = "Gratuluję właśnie zrealizowałeś założony cel!"
        } else if type == "message" {
            NotificationCenter.default.post(name: Notification.Name("message"), object: nil)
        } else if type == "payment" {
            NotificationCenter.default.post(name: Notification.Name("payment"), object: nil, userInfo: ["amount": amount ?? 10])
            content = "Czas wykonać zaplanowany przelew!"
        } else if type == "payment_confirm" {
            NotificationCenter.default.post(name: Notification.Name("payment_confirm"), object: nil)
            content = "Twoja płatność została potwierdzona!"
        } else {
            NotificationCenter.default.post(name: Notification.Name("message"), object: nil)
        }
        
        let banner = Banner(title: "Kosmolog", subtitle: content, image: UIImage(named: "chlopIcon"), backgroundColor: UIColor.defaultBlue())
        banner.dismissesOnTap = false
        banner.show(duration: 2.0)
        
        banner.didTapBlock = {
            NotificationCenter.default.post(name: Notification.Name("goToMessages"), object: nil)
        }
    }
}

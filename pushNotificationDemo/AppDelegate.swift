//
//  AppDelegate.swift
//  pushNotificationDemo
//
//  Created by JustMac on 11/12/24.
//

import UIKit
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      //...
       Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        UNUserNotificationCenter.current().delegate = self
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        SmartPush.sharedInstance().registerForPushNotification(authorizationOptions: [.alert, .badge, .sound])
      //...
      return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    //MARK:- UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      SmartPush.sharedInstance().willPresentForegroundNotification(notification)
      completionHandler([.alert, .badge, .sound])
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SmartPush.sharedInstance().didReceive(response)
      }
      
      completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SmartPush.sharedInstance().didReceiveRemoteNotification(userInfo, withCompletionHandler: completionHandler)
    }
    
    // MARK: - Smartech Delegate Methods

    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        print("SMTLogger: handleDeeplinkActionWithURLString")
        print("SMTLogger: Deeplink URL: \(deeplinkURLString)")
        print("SMTLogger: NotificationPayload: \(String(describing: notificationPayload))")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


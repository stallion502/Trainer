//
//  AppDelegate.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.object(forKey: "Food") == nil {
            ExercisesData.writeToDataBase()
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound], categories: nil))
            // Fallback on earlier versions
            
        }
        let locale = NSTimeZone.init(abbreviation: "GMT")
        NSTimeZone.default = locale! as TimeZone
        (window?.rootViewController as! UITabBarController ).tabBar.tintColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundTask = application.beginBackgroundTask(expirationHandler: { 
            self.backgroundTask = UIBackgroundTaskInvalid
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.endBackgroundTask(backgroundTask!)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


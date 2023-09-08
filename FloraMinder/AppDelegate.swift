//
//  AppDelegate.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/7/23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        
        let alarmCategory = UNNotificationCategory(
            identifier: Plant.notificationCategoryId,
            actions: [], // additional actions for notification
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([alarmCategory])
        center.delegate = self
        
        Task {
            await Plant.scheduleWaterReminderNotification()
        }

        return true
    }
    
    // Allow notifications to be shown while app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
    
}

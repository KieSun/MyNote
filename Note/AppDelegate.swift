//
//  AppDelegate.swift
//  Note
//
//  Created by yck on 2016/11/23.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 长按信息后显示的按钮
        UNUserNotificationCenter.current().delegate = self
        let action = UNNotificationAction(identifier: "check", title: " 确认", options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (bool, error) in
            
            if !bool {
                print("Notification access denied")
            }
        }
        
        return true
    }
    
    open func setupNotification(date: Date) {
        
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "提醒"
        content.body = "提示时间到啦"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myCategory"
        
//        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
//            
//            let url = URL(fileURLWithPath: path)
//            
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
//                content.attachments = [attachment]
//            } catch  {
//                print("error")
//            }
//        }
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if let error = error {
                print(error)
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "check" {

        }
        
        // 必写
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 前台显示通知的形式
        completionHandler([.alert, .sound])
    }
}


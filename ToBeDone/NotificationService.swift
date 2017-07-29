//
//  NotificationService.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

class NotificationService {
    
        
    static func enableLocalNotifications (application: UIApplication) {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
    }
    
    static func addLocalNotification(with alertBody: String, on deadline: Date) {
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.default
        notification.alertBody = alertBody// text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = deadline // due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        //notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        //notification.category = "TODO_CATEGORY"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
}

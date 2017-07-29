//
//  AppDelegate.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
     var window: UIWindow?
     let dbManager = RealmDBManager.sharedInstance
     let store = TodoItemStore.sharedInstance;
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationService.enableLocalNotifications(application: application)//enable notification
        
       // FIRApp.configure()//configure Firebase
        
        // fill realm db for test purpose

        //fillDBWithTestData()

        
     //   FirebaseService.syncData()
    
        return true
    }
    
    func fillDBWithTestData() {
        // inbox
        let item1 = TodoItemDTO()
        item1.title = "Buy milk"
        item1.state = "Inbox"
        item1.tags = ["errands", "life"]
        item1.note = "Buy some organic milk"
        
        // scheduled
        let item2 = TodoItemDTO()
        item2.title = "Go lunch with john"
        item2.state = "Scheduled"
        item2.note = "Remeber John doesn't like spicy food!"
        item2.scheduledDate = DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 1)
        
        let item6 = TodoItemDTO()
        item6.title = "meet with Kevin"
        item6.state = "Scheduled"
        item6.note = "Kevin will bring me to eat Sushi tonight"
        item6.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 2)
        
        let item7 = TodoItemDTO()
        item7.title = "watch <Western World>"
        item7.state = "Scheduled"
        item7.note = "This is the annual greaest TV series on HBO"
        item7.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 4)
        
        let item8 = TodoItemDTO()
        item8.title = "do the laundry"
        item8.state = "Scheduled"
        item8.note = "I need to clean my underwear and a pair of jeans, and my shoes"
        
        item8.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 7)
        let item9 = TodoItemDTO()
        item9.title = "return the keys"
        item9.checked = true
        item9.note = "The key is borrowed from Mike, lives in HV 105"
        item9.state = "Scheduled"
        
        item9.scheduledDate = DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 11)
        let item10 = TodoItemDTO()
        item10.title = "Watch Udacity Course"
        item10.checked = true
        item10.note = "The hardware course: High performance architecture is perfect"
        item10.state = "Scheduled"
        
        item10.scheduledDate = DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 1)
        // today
        let item3 = TodoItemDTO()
        item3.title = "Go jogging"
        item3.state = "Today"
        item3.note  = "Meet with Fan and go together to the central park for jogging"
        
        item3.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 0)
        let item34 = TodoItemDTO()
        item34.title = "Ask MSI service"
        item34.state = "Today"
        item34.note  = "There is something wrong with sound card in MSI laptop, need to check with the custom service today"
        
        item34.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 0)
        let item35 = TodoItemDTO()
        item35.title = "Ask Fedilis"
        item35.state = "Today"
        item35.note  = "Get to know which area does the Fedilis insurance company covered covered covered covered covered covered covered covered covered "
        
        item35.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 0)
        
        let item36 = TodoItemDTO()
        item36.title = "See a moive"
        item36.state = "Today"
        item36.note  = "The moive starts at 2: 00 pm"
        item36.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday: 0)
        // logbook
        let item4 = TodoItemDTO()
        item4.title = "buy eggs"
        item4.checked = true
        item4.note  = "I need organic eggs"
        item4.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday:0)
        item4.state = "Archived"
        
        let item11 = TodoItemDTO()
        item11.title = "fix the disk"
        item11.note = "the HDD is broken, I should buy a new SSD"
        item11.checked = true
        
        item11.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday:-28)
        item11.state = "Archived"
        // trash
        let item5 = TodoItemDTO()
        item5.title = "send email to Jim ask for Saturday's plan"
        
        item5.note = "Jim mentioned that we may go to the green lake this Saturday"
        item5.scheduledDate =  DateUtilities.stringFromScheduledDate(numOfDatesSinceToday:-11)
        item5.state = "Trash"
        
        
        
        
       
        
        store.add(item: item1)
        //FirebaseService.addItemToFirebase(with: item1)
        store.add(item: item2)
       // FirebaseService.addItemToFirebase(with: item2)
        store.add(item: item3)
        //FirebaseService.addItemToFirebase(with: item3)
        store.add(item: item4)
       // FirebaseService.addItemToFirebase(with: item4)
        store.add(item: item5)
       // FirebaseService.addItemToFirebase(with: item5)
        store.add(item: item6)
       // FirebaseService.addItemToFirebase(with: item6)
        store.add(item: item7)
      //  FirebaseService.addItemToFirebase(with: item7)
        store.add(item: item8)
      //  FirebaseService.addItemToFirebase(with: item8)
        store.add(item: item9)
       // FirebaseService.addItemToFirebase(with: item9)
        store.add(item: item10)
       // FirebaseService.addItemToFirebase(with: item10)
        store.add(item: item11)
          store.add(item: item34)
        store.add(item: item35)
        store.add(item: item36)
       // FirebaseService.addItemToFirebase(with: item11)
        print("adding success");
        
        let allTodoItems = store.getAllTodoItems()
        for (index, value) in allTodoItems.enumerated() {
            print(" item \(index) is  \(value.title)")
        }
        
        //FirebaseService.addDatabaseToFirebase(database: <#T##Dictionary<String, Any>#>)
        
        // print out db path
        
       dbManager.printDBFilePath()

        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }


}


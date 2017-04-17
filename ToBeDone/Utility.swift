//
//  Utility.swift
//  2BDone
//
//  Created by 周星 on 10/25/16.
//  Copyright © 2016 周星. All rights reserved.
//
// ver 1.0 :
// - if set dateFormat to "MM-dd-YYYY HH:mm:ss", will go wrong when convert from string to date

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class Debug: NSObject{
    
    // TODO: 为调试修改
    
    private static let debug = true
    
    class func log (message: String,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
    {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    }
    
    
}



// utility functions about date
class DateUtility {
    
    // MARK: constant
    static let customDateFormat = "MM-dd-yyyy HH:mm"
    
    /*
     function operation:  calculate the date from today based on the number of days passed in
     */
    static func stringFromScheduledDate (numOfDatesSinceToday: Int) -> String {
        let secondsSinceToday  = Double(numOfDatesSinceToday * 24 * 60 * 60)
        let scheduledDate = Date.init(timeIntervalSinceNow: secondsSinceToday)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = customDateFormat
        //w = .medium
        //dateformatter.timeStyle = .short
        
        return dateformatter.string(from: scheduledDate)
        
    }
    
    static func dateFrom(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customDateFormat
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        return dateFormatter.date(from: dateString)
    }
    
    //    static func localDateFrom(dateString: String) -> Date? {
    //        let dateFormatter = DateFormatter()
    //        //   dateFormatter.dateFormat = "MM-dd-YYYY HH:mm:ss"
    //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
    //        dateFormatter.dateStyle = .medium
    //        dateFormatter.timeStyle = .short
    //        return dateFormatter.date(from: dateString)
    //    }
    
    
    static func stringFromCurrentDate () -> String {
        
        let currentDate = Date()
        return stringFrom(date:currentDate)
        
    }
    
    static func stringFrom (date: Date) -> String {
        
        let dateformatter = DateFormatter()
        //     dateformatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)
        //dateformatter.dateStyle = .medium
        //dateformatter.timeStyle = .short
        dateformatter.dateFormat = customDateFormat
        return dateformatter.string(from: date)
        
    }
    
}



class NotificationUtility {
    
    static func enableLocalNotifications (application: UIApplication) {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
    }
    
    static func addLocalNotification(with alertBody: String, on deadline: Date) {
        let notification = UILocalNotification()
        notification.alertBody = alertBody// text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = deadline // due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        //notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        //notification.category = "TODO_CATEGORY"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}

class FirebaseUtility{
    
    static func parseData(from dictionary: Dictionary<String, Any>) -> TodoItem{
        let todoitem = TodoItem()
        
        todoitem.title = dictionary["title"] as? String ?? ""
        
        if let alerDate = dictionary["alertDate"] as? String{
            if alerDate != ""{
                todoitem.alertDate = alerDate
            }
        }
        
        if let scheduledDate = dictionary["scheduledDate"] as? String{
            if scheduledDate != ""{
                todoitem.scheduledDate = scheduledDate
            }
        }
        
        if let location = dictionary["location"] as? String{
            if location != ""{
                todoitem.location = location
            }
        }
        
        todoitem.state = (dictionary["state"] as? String)!
        
        if let checked = dictionary["checked"] as? String{
            if checked.lowercased() == "false"{
                todoitem.checked = false
            }
            else{todoitem.checked = true}
        }
        
        todoitem.note = dictionary["note"] as? String ?? ""
        
        todoitem.id = (dictionary["id"] as? String)!
        
        todoitem.createdDate = (dictionary["createdDate"] as? String)!
        
        todoitem.modifiedDate = dictionary["modifiedDate"] as? String
        
        if let tags = dictionary["tags"] as? [String: [String: String]]{
            
            for (tagIndex,tagValue) in tags {
                let tag = Tag()
                tag.tagName = tags[tagIndex]?["tagName"]
                tag.itemId = tagValue["itemId"]
                todoitem.tags.append(tag)
            }
        }
        
        if let images = dictionary["images"] as? [String: [String: String]]{
            
            for (imageIndex,imageValue) in images {
                let image = ImageFile()
                image.fileURL = images[imageIndex]?["fileURL"]
                image.itemId = imageValue["itemId"]
                image.imageId = imageValue["imageId"]!
                image.firebaseFileURL = imageValue["firebaseFileURL"]
                todoitem.images.append(image)
            }
        }
        
        
        return todoitem
    }
    
    static func getDictionary(from item: TodoItem) -> Dictionary<String, Any>{
        
        var itemDictionary = [String: Any]()
        
        itemDictionary["title"] = item.title
        itemDictionary["alertDate"] = item.alertDate ?? "" as Any
        itemDictionary["scheduledDate"] = item.scheduledDate ?? "" as Any
        itemDictionary["location"] = item.location  ?? "" as Any
        itemDictionary["state"] = item.state
        itemDictionary["checked"] = String(item.checked)
        itemDictionary["note"] = item.note
        itemDictionary["id"] = item.id
        itemDictionary["createdDate"] = item.createdDate
        itemDictionary["modifiedDate"] = item.modifiedDate
        
        if(item.tags.count != 0){
            var tagsDictionary = [String: Any]()
            
            for i in 0..<item.tags.count{
                tagsDictionary["tag\(i)"] = ["tagName": item.tags[i].tagName ?? "" as Any, "itemId": item.tags[i].itemId ?? "" as Any]
            }
            itemDictionary["tags"] = tagsDictionary
        }
        else{
            itemDictionary["tags"] = "NO_TAG"
        }
        
        if(item.images.count != 0){
            var imagesDictionary = [String: Any]()
            
            for i in 0..<item.images.count{
                imagesDictionary["image\(i)"] = ["imageId": item.images[i].imageId, "itemId": item.images[i].itemId ?? "" as Any, "fileURL" : item.images[i].fileURL ?? "" as Any, "firebaseFileURL": item.images[i].firebaseFileURL  ?? "" as Any]
            }
            itemDictionary["images"] = imagesDictionary
        }
        else{
            itemDictionary["images"] = "NO_IMAGE"
        }
        
        return itemDictionary
    }
    
    static func getDictionaryFromLocalDB( ) -> Dictionary<String, Any> {
        
        var dbDictionary = [String: Any]()
        let items = TodoItemStore.sharedInstance.getAllTodoItems()
        //var todoitem: TodoItem!
        
        for item in items{
            //todoitem = items[index]
            dbDictionary[item.id] = getDictionary(from: item)
        }
        
        return dbDictionary
    }
    
    static func getDictionaryFromFirebase() -> Dictionary<String, Any> {
        
        var remoteDBDictionary = [String: Any]()
        
        if let user = FIRAuth.auth()?.currentUser{
            let remoteDatabaseRef = FIRDatabase.database().reference().child("Users/\(user.uid)/database")
            remoteDatabaseRef.observeSingleEvent(of: .value, with: {(snapshot) in
                
                remoteDBDictionary = snapshot.value as? NSDictionary as! [String : Any]
            })
            return remoteDBDictionary
        }
        else{
            print("No user is logged in.")
        }
        
        
        return remoteDBDictionary
        
    }
    
    static func syncData(){
        let localdbDictionary = getDictionaryFromLocalDB()
        
        addDatabaseToFirebase(database: localdbDictionary)
    }
    
    static func addDatabaseToFirebase(database db: Dictionary<String, Any>){
        let ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            let userDatabase = ref.child("Users/\(user.uid)/database")
            //userDatabase.removeValue()
            userDatabase.setValue(db)
            
        }
        else{
            print("No user is logged in.")
        }
    }
    
    static func addItemToFirebase(with item: TodoItem){
        let itemDictionary = getDictionary(from: item)
        let ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            let userDatabaseItemRef = ref.child("Users/\(user.uid)/database/\(item.id)")
            //userDatabase.removeValue()
            userDatabaseItemRef.setValue(itemDictionary)
            
        }
        else{
            print("No user is logged in.")
        }
    }
    
    static func deleteItemFromFirebase(with item: TodoItem){
        let ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            let userDatabaseItemRef = ref.child("Users/\(user.uid)/database\(item.id)")
            userDatabaseItemRef.removeValue()
        }
        else{
            print("No user is logged in.")
        }
    }
    
    static func removeDatabaseFromFirebase(){
        let ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            let userDatabase = ref.child("Users/\(user.uid)/database")
            userDatabase.removeValue()
            
        }
        else{
            print("No user is logged in.")
        }
    }
    
    static func addPhotoToFirebase(from item: TodoItem){
        if let user = FIRAuth.auth()?.currentUser{
            //let storage = FIRStorage.storage()
            let storageUrl = FIRApp.defaultApp()?.options.storageBucket
            let storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
            let userImageStorageRef = storageRef.child("\(user.uid)/Images")
            let itemImagesStorageRef = userImageStorageRef.child("\(item.id)")
           
            for imageObj in item.images{
                let imagePath = itemImagesStorageRef.child("\(imageObj.imageId)")
                //let url  = NSURL(string: imagePath)
                 print("URL of photo being uploaded: \(imageObj.fileURL!)")
                //UIimage(
                //guard let image = UIImage(contentsOfFile: imageObj.fileURL!) else {print("ooooop"); return }
               // let imageData = UIImageJPEGRepresentation(image, 0.8)
                //let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                //NSFileManager.defaultManager().fileExistsAtPath(imageUrlPath)
                let url = NSURL(string: imageObj.fileURL!)
                guard let data = NSData(contentsOf: url! as URL) else{print("No Image found in path \(url)"); return }
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                imagePath.put(data as! Data, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    else{
                        imageObj.firebaseFileURL = String(describing: metadata!.downloadURLs)
                    }
                }
            }
            
        }
        else{
            print("no user is logged in.")
        }
    }
    
    static func downloadItemImage(item: TodoItem){
        if  let user = FIRAuth.auth()?.currentUser{
            let storageUrl = FIRApp.defaultApp()?.options.storageBucket
            let storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
            let userImageStorageRef = storageRef.child("\(user.uid)/Images")
            let itemImagesStorageRef = userImageStorageRef.child("\(item.id)")
            
            for imageObj in item.images{
                let imagePath = itemImagesStorageRef.child("\(imageObj.firebaseFileURL)")
                
                // Create local filesystem URL
                let localURL: NSURL! = NSURL(string: "file:///local/images/\(UUID().uuidString).jpg")
                
                // Download to the local filesystem
                let downloadTask = imagePath.write(toFile: localURL as URL) { (URL, error) -> Void in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                    } else {
                        // Local file URL for "images/island.jpg" is returned
                        print("Image downloaded!")
                    }
                }
            }
        }
        else{
            print("no user is logged in.")
        }
    }
    
    
}



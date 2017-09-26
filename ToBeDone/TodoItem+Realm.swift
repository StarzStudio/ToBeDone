//
//  TodoItem.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import RealmSwift


//enum State : String {
//    case deleted
//    case logged
//    case today
//    case scheduled
//    case inbox
//}


class ImageFile : Object {
    dynamic var fileURL : String!
    dynamic var itemId : String!
    dynamic var imageId = UUID().uuidString
    dynamic var firebaseFileURL : String?
    
}
class Tag : Object {
    dynamic var tagName : String!
    dynamic var itemId : String!
    
}

class TodoItem : Object {
    
    dynamic  var title : String! = ""
    dynamic  var alertDate : String?
    dynamic  var scheduledDate : String?
    dynamic  var location : String?
    dynamic  var state : String = "Inbox"
    dynamic  var checked : Bool = false
    dynamic  var  note : String?
    var tags = List<Tag>()
    var images = List<ImageFile>()
    
    //  var imageFiles = List<ImageFile>()
    
    dynamic var id  = ""
    dynamic var createdDate : String = {
        return DateUtilities.stringFromCurrentDate()
    }()
    
    dynamic var modifiedDate : String = {
        return DateUtilities.stringFromCurrentDate()
    }()

    

    override static func primaryKey() -> String {
        return "id"
    }
}


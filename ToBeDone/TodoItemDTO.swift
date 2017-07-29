//
//  TodoItemDTO.swift
//  ToBeDone
//
//  Created by 周星 on 4/20/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import UIKit

class TodoItemDTO {
    
    var title : String = ""
    var id : String = UUID().uuidString
    var createdDate = ""
    var alertDate : String?
    var scheduledDate : String?
    var location : String?
    var state : String = "Inbox"
    var checked : Bool = false
    var note : String?
    var tags = [String]()
    var images = [String : UIImage]()

}

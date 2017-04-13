//
//  SubTask.swift
//  ToBeDone
//
//  Created by 周星 on 11/3/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation

public struct SubTaskModel : Equatable {
    
    var title : String
    var checked : Bool
    
    public static func == (lhs: SubTaskModel, rhs: SubTaskModel) -> Bool {
        return (lhs.title == rhs.title ) && (lhs.checked == rhs.checked)
    }

}

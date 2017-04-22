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

class Debug: NSObject{
    
    // TODO: 为调试修改
    
    private static let debug = true
    
    class func log (message: String,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
    {
        if debug == true {
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        }
        
    }
    
    
}







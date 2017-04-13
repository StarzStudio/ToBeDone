//
//  RealmDBManager.swift
//  2BDone
//
//  Created by 周星 on 10/23/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import RealmSwift


class RealmDBManager {
    
     static let sharedInstance = RealmDBManager()
    
    private var db : Realm?
    
    public func createDB() -> Realm {
        
        if ((db) == nil) {
            deleteDBFile()
            db = try! Realm() // Create realm pointing to default file
        }
        return db!
}
    
    
    public func deleteDBFile() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {}
    }
    
    public func printDBFilePath(){
        print(" Real db file path is: \(Realm.Configuration.defaultConfiguration.fileURL!) ")
        
    }
}

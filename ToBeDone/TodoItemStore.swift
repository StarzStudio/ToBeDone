//
//  TodoItemStore.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import RealmSwift



class TodoItemStore {
    
    static let sharedInstance = TodoItemStore()
    
    private let db : Realm!
    
    let dbManager = RealmDBManager.sharedInstance
    
    init(){
      db = dbManager.createDB()
    }
    
    public func getAllTodoItems() -> Results<TodoItem>{
        let results = db.objects(TodoItem.self);
        return results;
    }
    

    public func query(stateName: String, property:String ) -> Results<TodoItem>! {
    
        let state = "state == \(stateName)"
        return  db.objects(TodoItem.self).filter(state).sorted(byProperty: property)
    }
    
    
    public func add(item : TodoItem) {
        try! db.write {
            db.add(item)
        }
    }
    
    public func update(item : TodoItem) {
        try! db.write {
            db.add(item, update: true)
        }
    }
    
    public func getDB() ->Realm!{
        return db
    }
    
    public func delete(item: TodoItem){
        try! db.write {
            db.delete(item)
        }
    }
    
    public func deleteAll(){
        try! db.write {
            db.deleteAll()
        }
    }
    
    public func deleteItem(withID id: String){
    
        let item = db.objects(TodoItem.self).filter("id == '\(id)'").first
        if(item != nil){
            delete(item: item!)
        }
        else{
            print("no such item.")
        }
        
    }
    
//    public func delete(publicitemID: UInt64) {
//    
//    }
//    public func update(item: TodoItem) {
//    
//    }
    


}


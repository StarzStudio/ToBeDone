//
//  AppState.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 12/3/16.
//  Copyright © 2016 周星. All rights reserved.
//


import Foundation
import FirebaseAuth

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
    
    override init() {
        if let user = FIRAuth.auth()?.currentUser {
            displayName = user.displayName ?? user.email
        }
        signedIn = true
    }
}

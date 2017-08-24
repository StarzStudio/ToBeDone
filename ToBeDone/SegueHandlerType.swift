//
//  SegueHandlerType.swift
//  ToBeDone
//
//  Created by 周星 on 11/3/16.
//  Copyright © 2016 周星. All rights reserved.
//


import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier : RawRepresentable
}


extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject) {
        
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
    
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else {
                fatalError("invalid segue identifier \(String(describing: segue.identifier))")
        }
        return segueIdentifier
    
    }
}

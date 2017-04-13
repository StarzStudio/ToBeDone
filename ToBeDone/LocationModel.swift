//
//  LocationModel.swift
//  ToBeDone
//
//  Created by 周星 on 11/9/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation

public struct LocationModel : Equatable {
    
    var placeName : String?
    
    public static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.placeName == rhs.placeName
    }
}

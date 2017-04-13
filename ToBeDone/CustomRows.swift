//
//  CustomCells.swift
//  ToBeDone
//
//  Created by 周星 on 10/31/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import Eureka
import MapKit



public final  class SubTaskRow: Row<SubTaskTableCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SubTaskTableCell>(nibName: "SubTaskTableCell")
    }
}



public final class LocationRow : Row<LocationCell>, RowType {
    
  
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<LocationCell>(nibName: "LocationCell")
    }
}





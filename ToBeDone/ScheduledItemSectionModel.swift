//
//  itemSectionModel.swift
//  ToBeDone
//
//  Created by 周星 on 8/3/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

//
//enum SectionType {
//    case TodaySection
//    case ScheduleSection
//    case NormalSection
//}


class ScheduledItemSectionModel {
    var index : Int?
    //var type : SectionType?
    var title : String?
    var itemCells = [ItemCellModel]()
    
}

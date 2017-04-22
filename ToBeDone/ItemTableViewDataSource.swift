//
//  ItemTableViewDataSource.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

extension ItemTableViewController {
    
     override func numberOfSections(in tableView: UITableView) -> Int {//number of section
        
        if items.count == 0 {
            return 0
        }
        
        if sections.count > 1{ return sections.count}
        return 1
    }
    
     v func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//section's title
        if sections.count > 1{
            let scheduledDate = convertTime(fromString: sections[section][0].scheduledDate!)
            let isToday = checkIfDateIsToday(date: scheduledDate)
            if isToday{return "Today"}
            
            return getTimeInStringFrom(time: scheduledDate, withFormat: "EEE, MMM dd, yyyy")
        }
        
        return ""
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of item in each section
        if sections.count > 1{
            return sections[section].count
        }
        return items.count
    }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//load data into each row
        var logBookCell : LogBookItemCell!
        var TrashCell :TrashCell!
        var photoitemCell: newTableCell!
        var noPhotoItemCell:newTableCellWithNoPhoto!
        var item: TodoItem!
        
        switch collectionType! {
            
        case "Trash":
            TrashCell = tableView.dequeueReusableCell(withIdentifier: "TrashCell", for: indexPath) as! TrashCell
            
            item = items[indexPath.row]
            TrashCell.itemTitle.text = item.title
            return TrashCell
            
        case "LogBook" :
            logBookCell = tableView.dequeueReusableCell(withIdentifier: "LogBookItemCell", for: indexPath) as! LogBookItemCell
            
            item = items[indexPath.row]
            var dateScheduled: String!
            if item.scheduledDate != nil {
                let isToday = checkIfDateIsToday(date: convertTime(fromString: item.scheduledDate!))
                if isToday {dateScheduled = "Today"}
                else{
                    dateScheduled = getTimeInStringFrom(time: convertTime(fromString: item.scheduledDate!), withFormat: "MMM dd")
                }
                
            }
            else {
                dateScheduled = ""
            }
            logBookCell.itemTitle?.text = item.title
            logBookCell.dateLabel?.text = dateScheduled
            return logBookCell
            
            
        default:
            
            
            if collectionType! == "Scheduled"{
                item = sections[indexPath.section][indexPath.row]
            }
            else{
                item = items[indexPath.row]
            }
            // no photo cell verson
            if item.images.count == 0 {
                noPhotoItemCell = tableView.dequeueReusableCell(withIdentifier: "newTableCellWithNoPhoto", for: indexPath) as! newTableCellWithNoPhoto
                noPhotoItemCell.fillDataWrapper(item: item)
                return noPhotoItemCell
            } else {
                photoitemCell = tableView.dequeueReusableCell(withIdentifier: "newTableCell", for: indexPath) as! newTableCell
                photoitemCell.fillDataIntoCollectionCellViewController(item)
                // flow : itemCell awakeFromNib, fillData , CollectionCellViewController view didload -> getViewContent->setViewContent
                
                return photoitemCell
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //
        //        if cell is LogBookItemCell {
        //            return 44
        //        }
        //        if cell is TrashCell {
        //            return 44
        //        }
        //
        //        if cell is newTableCell {
        //            return  213
        //        }
        //        print ("no cell match, return height 0")
        return 213
    }
    
}

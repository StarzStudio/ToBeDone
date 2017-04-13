//
//  ToDoItemsViewController.swift
//  2BDone
//
//  Created by Xinghe Lu on 10/26/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoItemsViewController: UITableViewController{

    var items: Results<TodoItem>!
    var collectionType: String?
    var sections = [[TodoItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //group items into sections
        if collectionType != nil && collectionType! == "Scheduled"{
            groupItemsByDate()
            //print("section size" + " " + String(sections.count))
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        //following two lines codes aim to eliminate extra separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("table view appear")
    }
    override func viewDidDisappear(_ animated: Bool) {
            print("table view disappear")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {//number of section
        if sections.count > 1{ return sections.count}
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//section's title
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
        
        var defaultItemCell: DefaultItemCell!
        var trashItemCell: UITableViewCell!
        var logBookCell: LogBookItemCell!
        var item: TodoItem!
    
        switch collectionType! {
        
        case "Trash":
            trashItemCell = tableView.dequeueReusableCell(withIdentifier: "TrashCell", for: indexPath)
            item = items[indexPath.row]
            trashItemCell.textLabel?.text = item.title
            
            return trashItemCell
        
        case "LogBook" :
                logBookCell = tableView.dequeueReusableCell(withIdentifier: "LogBookCell", for: indexPath) as! LogBookItemCell
                item = items[indexPath.row]
                var dateScheduled: String!
                let isToday = checkIfDateIsToday(date: convertTime(fromString: item.scheduledDate!))
                if isToday {dateScheduled = "Today"}
                else{dateScheduled = getTimeInStringFrom(time: convertTime(fromString: item.scheduledDate!), withFormat: "MMM dd")}
                logBookCell.itemTitle?.text = item.title
                logBookCell.dateLabel?.text = dateScheduled
                if item.checked == true{logBookCell.isChecked = true}
                else{logBookCell.isChecked = false}
                
                return logBookCell

            
        default:
                defaultItemCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultItemCell
                
                if collectionType! == "Scheduled"{
                    item = sections[indexPath.section][indexPath.row]
                }
                else{item = items[indexPath.row]}
                
                defaultItemCell.itemTitle?.text = item.title
              //  defaultItemCell.elapsedTimeLabel.date = item.createdDate.date(inFormat: customDateFormat) as NSDate?
                if  item.checked == true{defaultItemCell.isChecked = true}
                else{defaultItemCell.isChecked = false}
                
                return defaultItemCell
            
        }
    }
    
    
    fileprivate func convertTime(fromString: String) -> Date {//convert time in String to Date
        let dateString = fromString
        //print("\nconvert time sting" + dateString)
        let dateFormatter = DateFormatter()
       // dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)//time zone GMT + 0
       // dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date = dateFormatter.date(from: dateString)
        //print("convert time" + String(describing: date!))
        
        return date!
    }
    
    fileprivate func groupItemsByDate() {//catagorize items into sections by date
        var lastDate = convertTime(fromString: (items.first?.scheduledDate)!)
        var lastSection = [TodoItem]()
        
        for item in items{
            let currentDate = convertTime(fromString: item.scheduledDate!)
            //print("\nlast day: " + String(describing: lastDate) + "current day: " + String(describing: currentDate))
            let difference = compareDates(from: lastDate, to: currentDate)
            if difference.year! > 0 || difference.month! > 0 || difference.day! > 0{
                lastDate = currentDate
                sections.append(lastSection)
                lastSection = [item]
            }
            else{
                lastSection.append(item)
            }
        }
        sections.append(lastSection)
    }
    
    fileprivate func compareDates(from dateOne: Date, to dayTwo: Date) -> DateComponents {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let difference = calendar.dateComponents(unitFlags, from: dateOne, to: dayTwo)

        return difference
    }
    
    fileprivate func getCurrentLocalDate() -> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = calendar.component(.day, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    fileprivate func getTimeInStringFrom(time: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)//time zone GMT + 0
        dateFormatter.dateFormat = format
        let timeInString = dateFormatter.string(from: time)
        
        return timeInString
    }
    
    fileprivate func checkIfDateIsToday(date:Date) -> Bool {
        let difference = compareDates(from: date, to: getCurrentLocalDate())
        if difference.year == 0 && difference.month == 0 && difference.day == 0{return true}
        else{return false}
    }
}

extension ToDoItemsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item: TodoItem! = TodoItem()
        
        switch collectionType! {
            
        case "Trash":
            // the cell will shown as grey color to indicate this can not be clicked
            break
        case "LogBook" :
            fallthrough
        default:
            
            if collectionType! == "Scheduled" {
                item = sections[indexPath.section][indexPath.row]
            }
            else {
                item = items[indexPath.row]
            }
            
            let itemDetailVC = UIStoryboard(name: "ItemDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController" ) as! ItemDetailViewController
            //print("before pushViewController")
            self.navigationController?.pushViewController(itemDetailVC, animated: true)
            //print("after pushViewController")
            itemDetailVC.isNewAddingItem = false
            itemDetailVC.item = item
            setNavigationControllerForItemDetail(detailView: itemDetailVC)
        }
    }
    
    
    private func setNavigationControllerForItemDetail (detailView : UIViewController) {
        
        
        let titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:100, height: 30))
        titleLabel.text = "New Todo!"
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        detailView.navigationItem.titleView = titleLabel
        
     //   let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemDetail))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.leftNaviBarItemActionForItemDetail))
      //  detailView.navigationItem.rightBarButtonItem = rightItem
        detailView.navigationItem.leftBarButtonItem = leftItem
    }
    
    func leftNaviBarItemActionForItemDetail() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func rightNaviBarItemActionForItemDetail() {
//        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//        if let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
//        self.navigationController?.popViewController(animated: true)
//        mainVC.showDemoControllerForIndex(7)
//        }
//    
//    }
    

    
}

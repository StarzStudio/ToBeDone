//
//  TodoItemsViewController2.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 11/22/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import FoldingCell
import RealmSwift

class ItemTableViewController: UITableViewController{
    
    
    var viewModel = ItemTableViewModel.sharedInstance
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //group items into sections
        
        /*for i in 0..<items.count{
            print("\(items[i].title!)'s scheduled date is \(items[i].scheduledDate!)")
        }*/
        //tableView.register(UINib.init(nibName: "CollectionCellView", bundle: nil), forCellReuseIdentifier: "newTableCellTableViewCell")
        
        prepareData()
        setTableView()
        notificationCenterSetup()
    }
    
    private func setTableView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = insets
        self.automaticallyAdjustsScrollViewInsets = false
        
        // auto calculate cell's height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        
        //following two lines codes aim to eliminate extra separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        tableView.backgroundColor = UIColor.flatGray
    }
    
    func prepareData() {
       
    }
    

    
   
    
    
    fileprivate func convertTime(fromString: String) -> Date {//convert time in String to Date
        let dateString = fromString
        //print("\nconvert time sting" + dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)//time zone GMT + 0
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
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
        //nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    fileprivate func getTimeInStringFrom(time: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()

      //  dateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 0)//time zone GMT + 0

        dateFormatter.dateFormat = format
       // dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        let timeInString = dateFormatter.string(from: time)
        
        return timeInString
    }
    
    fileprivate func checkIfDateIsToday(date:Date) -> Bool {
        let difference = compareDates(from: date, to: getCurrentLocalDate())
        if difference.year == 0 && difference.month == 0 && difference.day == 0{return true}
        else{return false}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
       
    private func setNavigationControllerForItemDetail (detailView : UIViewController) {
        
        
        let titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:100, height: 30))
        titleLabel.text = "New Todo!"
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        detailView.navigationItem.titleView = titleLabel
        
        //  let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemDetail))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.leftNaviBarItemActionForItemDetail))
        detailView.navigationItem.rightBarButtonItem = nil
        detailView.navigationItem.leftBarButtonItem = leftItem
    }
    
    func leftNaviBarItemActionForItemDetail() {
        
        self.navigationController?.popViewController(animated: true)
    }

    


    
    
    
    fileprivate func notificationCenterSetup() {
        let updateTableView = NSNotification.Name(rawValue:"updateTableView")
        NotificationCenter.default.addObserver(self, selector:#selector(reloadTable), name: updateTableView, object: nil)
    }
    
    func reloadTable() {
        for item in items {
            if item.checked == true {
                
                try! db.write {
                    item.state = "LogBook"
                }

                
                
            }
        }
        tableView.reloadData()
    }
    
    
    


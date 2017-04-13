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

class ToDoItemsViewController2: UITableViewController{
    
    var collectionDetailCellViewController : CollectionCellViewController!
    var items: Results<TodoItem>!
    var collectionType: String?
    var sections = [[TodoItem]]()
    var cellHeights = [[CGFloat]]()
    var inList = true, inMosaic = false
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 65 // equal or greater foregroundView height
            static let open: CGFloat = 600 // equal or greater containerView height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //group items into sections
        
        /*for i in 0..<items.count{
            print("\(items[i].title!)'s scheduled date is \(items[i].scheduledDate!)")
        }*/
        
        prepareData()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 65
        //following two lines codes aim to eliminate extra separators
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
    }
    
    func prepareData() {
        sections.removeAll()
        cellHeights.removeAll()
        if collectionType != nil && collectionType! == "Scheduled" && items.count != 0{
            groupItemsByDate()
            print("section size" + " " + String(sections.count))
            for i in 0..<sections.count{
                let cellHeightsinSectioni = (0..<sections[i].count).map { _ in C.CellHeight.close }
                cellHeights.append(cellHeightsinSectioni)
            }
        }
        
        if collectionType != nil && collectionType! != "Scheduled"{
            let cellHeightsinSection0 = (0..<items.count).map { _ in C.CellHeight.close }
            cellHeights.append(cellHeightsinSection0)
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {//number of section
        
        if items.count == 0 {
            return 0
        }
        
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
        
        var itemCell: MyFoldingCell!
        var item: TodoItem!
        
        switch collectionType! {
            
        case "Trash":
            itemCell = tableView.dequeueReusableCell(withIdentifier: "TrashCell2", for: indexPath) as! MyFoldingCell
            item = items[indexPath.row]
            itemCell.itemTitle?.text = item.title

        case "LogBook" :
            itemCell = tableView.dequeueReusableCell(withIdentifier: "LogBookCell2", for: indexPath) as! MyFoldingCell
            item = items[indexPath.row]
            var dateScheduled: String!
            let isToday = checkIfDateIsToday(date: convertTime(fromString: item.scheduledDate!))
            if isToday {dateScheduled = "Today"}
            else{dateScheduled = getTimeInStringFrom(time: convertTime(fromString: item.scheduledDate!), withFormat: "MMM dd")}
            itemCell.itemTitle?.text = item.title
            itemCell.dateLabel?.text = dateScheduled
            if item.checked == true{itemCell.isChecked = true}
            else{itemCell.isChecked = false}
            itemCell.tableView = self.tableView
            itemCell.cellIndexPath = indexPath
            itemCell.todolistviewcontroller = self
            
        default:
            itemCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell2", for: indexPath) as! MyFoldingCell
            
            if collectionType! == "Scheduled"{
                item = sections[indexPath.section][indexPath.row]
            }
            else{item = items[indexPath.row]}
            
            itemCell.itemTitle?.text = item.title
            if  item.checked == true{itemCell.isChecked = true}
            else{itemCell.isChecked = false}
  
        }
        
        return itemCell
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
                return
        }
        
      
                
        var duration = 0.0
        weak var weakSelf = self
        if cellHeights[indexPath.section][indexPath.row] == C.CellHeight.close { // open cell
            
           
            cellHeights[indexPath.section][indexPath.row] = C.CellHeight.open

            weakSelf!.fillDataToContainerView(tableView, didSelectRowAt: indexPath)
            
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.section][indexPath.row] = C.CellHeight.close

            cell.containerView.subviews[0].removeFromSuperview()

            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
    }
    
    
    fileprivate func fillDataToContainerView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        
        var item = TodoItem()
        
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
            
            let collectionDetailCellViewControllerStoryBoard = UIStoryboard.init(name: "TodoItemTableList", bundle: nil)
            collectionDetailCellViewController  =  collectionDetailCellViewControllerStoryBoard.instantiateViewController(withIdentifier: "CollectionCellViewController") as! CollectionCellViewController
            
            var images = Array<UIImage>()
            var tags = Array<String>()
            let itemTitle:String
            
            for imageModel in item.images {
                let image = UIImage(contentsOfFile: imageModel.fileURL! )
                images.append(image!)
            }
            
            for tagModel in item.tags {
                tags.append(tagModel.tagName!)
            }
            
            itemTitle = item.title
            collectionDetailCellViewController.getViewContent( images: images, title: itemTitle)
            cell.containerView.addSubview(collectionDetailCellViewController.view)
            collectionDetailCellViewController.view.frame = cell.containerView.bounds
            
        }
    }
        
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.section][indexPath.row] == C.CellHeight.close {
                cell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                cell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            if !inList{
                //self.performSegue(withIdentifier: "GoToViewController", sender:self)
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoItemsViewController2") as! ToDoItemsViewController2
                //self.navigationController?.pushViewController(secondViewController, animated: true)
                self.present(secondViewController, animated:true, completion:nil)
                inList = true
                inMosaic = false
            }
        case 1:
            if !inMosaic{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MosaicViewController") as! MyCollectionViewController
                
                secondViewController.items = items
                secondViewController.collectionType = collectionType
                self.navigationController?.pushViewController(secondViewController, animated: true)
                 //self.present(secondViewController, animated:true, completion:nil)
                //inMosaic = true
                //inList = false
            }
        default:
            break; 
        }
    }
    
}

/*extension ToDoItemsViewController2 {
    
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
    
    
    
}*/

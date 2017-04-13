//
//  MenuViewController.swift
//  ToBeDone
//
//  Created by 周星 on 11/28/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UIColor {
    /**
     Creates a color from an hex int.
     
     - parameter hexString: A hexa-decimal color number representation.
     */
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}


struct MenuItem {
    let name : String?
    let image : UIImage?
    let unfinishedNum : Int?
}

class MenuViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate  {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var db = TodoItemStore.sharedInstance

    
    
 let DismissSegueName = "DismissMenuSegue"
    var menuItemIndex:Int = 0
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    
    let CellName  = "MenuItemCell"
    
    var unfinishedNumDic: Dictionary<String,Int> = ["Inbox":0, "Today": 0, "Scheduled":0]
    var menuList = [MenuItem(name: "",image: UIImage(),unfinishedNum: 0)]
    
    let mainColor = UIColor(hex: 0xC4ABAA)
    
    func calculateRemainingItems() {
       let items =  db.getAllTodoItems()
        for item in items {
            switch item.state {
                case "Inbox":
                unfinishedNumDic["Inbox"] = unfinishedNumDic["Inbox"]! + 1
                case "Today":
                unfinishedNumDic["Today"] = unfinishedNumDic["Today"]! + 1
                case "Scheduled":
                unfinishedNumDic["Scheduled"] = unfinishedNumDic["Scheduled"]! + 1
            default:
                break
                
            }
        }
        
        print("\(unfinishedNumDic)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBar.tintColor              = .black
        topBar.barTintColor           = mainColor
        topBar.titleTextAttributes    = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
            NSForegroundColorAttributeName: UIColor.flatBlack
        ]
        userTableView.backgroundColor = mainColor
        view.backgroundColor          = mainColor
        
        calculateRemainingItems()
        
        menuList = [MenuItem(name: "inbox", image: UIImage(named: "inbox_menu"),unfinishedNum:  unfinishedNumDic["Inbox"]),
                        MenuItem(name: "Today", image: UIImage(named: "today_menu"), unfinishedNum: unfinishedNumDic["Today"]) ,
                        MenuItem(name: "Schedule", image: UIImage(named: "scheduled_menu"), unfinishedNum: unfinishedNumDic["Scheduled"]),
                        MenuItem(name: "Logbook", image: UIImage(named: "logbook_menu"), unfinishedNum: 0),
                        MenuItem(name: "Trash", image: UIImage(named: "trash_menu"), unfinishedNum: 0),
                        MenuItem(name: "Setting", image: UIImage(named: "setting_menu"), unfinishedNum: 0)]
        
        
    }
      
    // MARK: - Managing the Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UITableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellName) as! MenuItemCell
        
        let menuItem = menuList[(indexPath as NSIndexPath).row]
        
        cell.menuItemName.text = menuItem.name
        cell.menuItemImageView.image =  menuItem.image
        if menuItem.unfinishedNum == 0 {
            cell.unfinishedNumLabel.isHidden  = true
        } else {
             cell.unfinishedNumLabel.isHidden  = false
             cell.unfinishedNumLabel.text = menuItem.unfinishedNum?.description
        }
    
        cell.contentView.backgroundColor = mainColor
        
        return cell
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select row at \(indexPath)")
        
        menuItemIndex = (indexPath as NSIndexPath).row + 1
        performSegue(withIdentifier: DismissSegueName, sender: self)
     
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let mainViewController = segue.destination as! MainViewController
        
        if menuItemIndex != 0 {
              mainViewController.showDemoControllerForIndex(menuItemIndex)
        }
      
    }
    


}

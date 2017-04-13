//
//  MainMenuViewController.swift
//  ToBeDone
//
//  Created by 周星 on 11/28/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import FlowingMenu
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Toast_Swift


class MainViewController: UIViewController  {
    
    // MARK: - Property
    let todoItemStore  = TodoItemStore.sharedInstance
    struct TableViewContent {
        var items: Results<TodoItem>?
        var collectionType: String?
        var title : String?
    }
    
    
    @IBOutlet weak var subViewContainerView: UIView!
    
    
    @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!
    
    let PresentSegueName = "PresentMenuSegue"
    let DismissSegueName = "DismissMenuSegue"

    
    
    let mainColor      = UIColor(hex: 0x804C5F)
    let derivatedColor = UIColor(hex: 0x794759)
    var selectedIndex = 2
    var selectedTable:UITableViewController?
    var menu: UIViewController?
    var counter = 0
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
        
        view.backgroundColor          = mainColor
        

        //add whole local database to firebase
        //FirebaseUtility.syncData()
        
        
        configureDatabase()
        
        
    }
    
    deinit {
        if let user = FIRAuth.auth()?.currentUser{
            self.ref.child("/Users/\(user.uid)/database").removeObserver(withHandle: _refHandle)
        }
    }

    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            // Listen for new messages in the Firebase database
            _refHandle = self.ref.child("/Users/\(user.uid)/database").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                
                
                    let itemDictionary = snapshot.value as? NSDictionary as! [String : Any]
                    let item = FirebaseUtility.parseData(from: itemDictionary)
                    strongSelf.todoItemStore.update(item: item)
                    print("New item: \(item.title)")
                    if  strongSelf.selectedTable is ToDoItemsViewController2 {
                        
                        let table = strongSelf.selectedTable as! ToDoItemsViewController2
                        print("\(item.state)")
                        print("\(table.collectionType!)")
                        if item.state == table.collectionType!{
                            print("wutttt")
                            //table.items = strongSelf.todoItemStore.query(stateName: "'\(table.collectionType!)'", property: "scheduledDate")
                            
                            table.prepareData()
                            table.tableView.reloadData()
                    }
                }
            })
            self.ref.child("/Users/\(user.uid)/database").observe(.childRemoved, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                let itemDictionary = snapshot.value as? NSDictionary as! [String : Any]
                let item = FirebaseUtility.parseData(from: itemDictionary)
                strongSelf.todoItemStore.deleteItem(withID: item.id)
                print("item removed: \(item.title!)")
                if  strongSelf.selectedTable is ToDoItemsViewController2 {
                    print("sdasd)")
                    let table = strongSelf.selectedTable as! ToDoItemsViewController2
                    print("\(item.state)")
                    print("\(table.collectionType!)")
                    if item.state == table.collectionType!{
                        //table.items = strongSelf.todoItemStore.query(stateName: "'\(table.collectionType!)'", property: "scheduledDate")
                        print("sdasdasdasd)")
                        table.prepareData()
                        table.tableView.reloadData()
                    }
                }
            })
        }
        //self.showDemoControllerForIndex(selectedIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("main view appear")
        print ("view appear: selected Index: \(selectedIndex)")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("main view disappear")
        
           print ("view disappear: selected Index: \(selectedIndex)")
    }

    
    // MARJ: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PresentSegueName {
            let vc                   = segue.destination
            vc.transitioningDelegate = flowingMenuTransitionManager
            
            flowingMenuTransitionManager.setInteractiveDismissView(vc.view)
            
            menu = vc
        }
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) {
    }
    
    // MARK: - Managing the Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    enum DestinationVCType : Int {
        case IntroVC
        case InboxTableVC, TodayTableVC, ScheduledTableVC, LogBookTableVC, TrashTableVC
        case SettingVC
        
    }

    
    fileprivate func findDestinationType (index: Int) ->DestinationVCType?{
        return DestinationVCType(rawValue: index)
    }
    
    
    fileprivate func setDestinationVCContent(type: DestinationVCType) -> TableViewContent{
        
        var tableViewContent = TableViewContent()
        
        switch type {
        case .InboxTableVC:
            tableViewContent.items = todoItemStore.query(stateName: "'Inbox'", property:"scheduledDate")
            tableViewContent.collectionType = "Inbox"
        case .ScheduledTableVC:
            tableViewContent.items = todoItemStore.query(stateName: "'Scheduled'", property: "scheduledDate")
            tableViewContent.collectionType = "Scheduled"
        case .TodayTableVC:
            tableViewContent.items = todoItemStore.query(stateName: "'Today'", property: "scheduledDate")
            tableViewContent.collectionType = "Today"
        case .LogBookTableVC:
            tableViewContent.items = todoItemStore.query(stateName: "'LogBook'", property: "scheduledDate")
            tableViewContent.collectionType = "LogBook"
        case .TrashTableVC:
            tableViewContent.items = todoItemStore.query(stateName: "'Trash'", property: "scheduledDate")
            tableViewContent.collectionType = "Trash"
        default:
            break
        }
        return tableViewContent
    }
    
    fileprivate func  fillSubContainerView(type: DestinationVCType,  tableViewContent: TableViewContent){
        
      
        
        let items = tableViewContent.items
        let collectionType = tableViewContent.collectionType
        
        
        switch type {
        case .InboxTableVC:
            fallthrough
        case .ScheduledTableVC:
            fallthrough
        case .TodayTableVC:
            fallthrough
        case .LogBookTableVC:
            fallthrough
        case .TrashTableVC:
            let toDoItemTableListStoryboard = UIStoryboard.init(name: "TodoItemTableList", bundle: nil)
            if let toDoItemTableListVC = toDoItemTableListStoryboard.instantiateInitialViewController() as?ToDoItemsViewController2 {
                toDoItemTableListVC.items = items
                toDoItemTableListVC.collectionType = collectionType
                let tableTitle = tableViewContent.collectionType
                fillSubViewForContainerView(table: toDoItemTableListVC, title: tableTitle)
        
            }
       
            
        case .SettingVC:
            let settingStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
            if let settingVC = settingStoryboard.instantiateViewController(withIdentifier: "StaticSettingController") as? StaticSettingController {
                fillSubViewForContainerView(table: settingVC, title: "Setting")
            }
        default:
            break;
        }
        
        
    }
    

    
    public func showDemoControllerForIndex(_ selectedIndexInMenu:Int){
        
        
            self.selectedIndex = selectedIndexInMenu
        
        
        
           print ("showDemoControllerForIndex: selected Index: \(selectedIndex)")
        if selectedTable != nil {
            selectedTable!.view.removeFromSuperview()
            selectedTable!.removeFromParentViewController()
            selectedTable = nil
        }
        
        
        let destinationType = findDestinationType(index: selectedIndexInMenu)!
        let tableViewContent = setDestinationVCContent(type: destinationType)
        fillSubContainerView(type: destinationType, tableViewContent: tableViewContent)
        
        
    }

   
    

    fileprivate func fillSubViewForContainerView (table : UITableViewController, title: String?) {
        
        self.selectedTable = table
        self.addChildViewController(table)
        self.subViewContainerView.addSubview(selectedTable!.tableView)
        
        let titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:100, height: 30))
        titleLabel.text = title
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = titleLabel
        let rightItem1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.rightNaviBarItemActionForItemTable1))
        let rightItem2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemTable2))
       self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItems = [rightItem1,rightItem2]
        
    }
    
    func rightNaviBarItemActionForItemTable1() {
        updateTableViewAction()
    }
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
    func rightNaviBarItemActionForItemTable2() {
        
        let itemDetailStoryboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        if let itemDetailVC = itemDetailStoryboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
        
            setNavigationControllerForItemDetail(detailView: itemDetailVC)
            self.navigationController?.pushViewController(itemDetailVC, animated: true)
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
        
        //  let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemDetail))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.leftNaviBarItemActionForItemDetail))
        detailView.navigationItem.rightBarButtonItem = nil
        detailView.navigationItem.leftBarButtonItem = leftItem
    }
    
    func leftNaviBarItemActionForItemDetail() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension MainViewController : FlowingMenuDelegate {
    // MARK: - FlowingMenu Delegate Methods
    
    func colorOfElasticShapeInFlowingMenu(_ flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        return mainColor
    }
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName, sender: self)
        showDemoControllerForIndex(self.selectedIndex)
           print ("flowingMenuNeedsDismissMenu: selected Index: \(selectedIndex)")
    }

}


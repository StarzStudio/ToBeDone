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


enum DestinationVCType : Int {
    
    case InboxTableVC, TodayTableVC, ScheduledTableVC, ArchivedTableVC
    case SettingVC
    
}

class MainViewController: UIViewController  {
    
    // MARK: - Property
    
 

    
    
    @IBOutlet weak var subViewContainerView: UIView!
    
    
    @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!
    
    let PresentSegueName = "PresentMenuSegue"
    let DismissSegueName = "DismissMenuSegue"

    
    
    var viewModel = MainViewModel.sharedInstance
    
    var selectedIndex = 2
    var selectedTable:UITableViewController?
    var menu: UIViewController?
    
    
   // var ref: FIRDatabaseReference!
    // fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
        
        showItemTableForIndex(0);
        
        //add whole local database to firebase
        //FirebaseService.syncData()
        
        
       // configureDatabase()
        
        
    }
    
//    deinit {
//        if let user = FIRAuth.auth()?.currentUser{
//            self.ref.child("/Users/\(user.uid)/database").removeObserver(withHandle: _refHandle)
//        }
//    }

    
//    func configureDatabase() {
//        ref = FIRDatabase.database().reference()
//        if let user = FIRAuth.auth()?.currentUser{
//            // Listen for new messages in the Firebase database
//            _refHandle = self.ref.child("/Users/\(user.uid)/database").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//                guard let strongSelf = self else { return }
//                
//                
//                    let itemDictionary = snapshot.value as? NSDictionary as! [String : Any]
//                    let item = FirebaseService.parseData(from: itemDictionary)
//                    strongSelf.todoItemStore.update(item: item)
//                    print("New item: \(item.title)")
//                    if  strongSelf.selectedTable is ToDoItemsViewController2 {
//                        
//                        let table = strongSelf.selectedTable as! ToDoItemsViewController2
//                        print("\(item.state)")
//                        print("\(table.collectionType!)")
//                        if item.state == table.collectionType!{
//                            print("wutttt")
//                            //table.items = strongSelf.todoItemStore.query(stateName: "'\(table.collectionType!)'", property: "scheduledDate")
//                            
//                            table.prepareData()
//                            table.tableView.reloadData()
//                    }
//                }
//            })
//            self.ref.child("/Users/\(user.uid)/database").observe(.childRemoved, with: { [weak self] (snapshot) -> Void in
//                guard let strongSelf = self else { return }
//                let itemDictionary = snapshot.value as? NSDictionary as! [String : Any]
//                let item = FirebaseService.parseData(from: itemDictionary)
//                strongSelf.todoItemStore.deleteItem(withID: item.id)
//                print("item removed: \(item.title!)")
//                if  strongSelf.selectedTable is ToDoItemsViewController2 {
//                    print("sdasd)")
//                    let table = strongSelf.selectedTable as! ToDoItemsViewController2
//                    print("\(item.state)")
//                    print("\(table.collectionType!)")
//                    if item.state == table.collectionType!{
//                        //table.items = strongSelf.todoItemStore.query(stateName: "'\(table.collectionType!)'", property: "scheduledDate")
//                        print("sdasdasdasd)")
//                        table.prepareData()
//                        table.tableView.reloadData()
//                    }
//                }
//            })
//        }
//        //self.showDemoControllerForIndex(selectedIndex)
//    }
//    
    
    
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
    
    
    fileprivate func  loadTableView(type: DestinationVCType){
        
        
        var tableViewState = ""
        switch type {
        case .InboxTableVC:
            tableViewState = "Inbox"
            initTableView(withState: tableViewState)
        case .ScheduledTableVC:
            tableViewState = "Scheduled"
            initTableView(withState: tableViewState)
        case .TodayTableVC:
            tableViewState = "Today"
            initTableView(withState: tableViewState)
        case .ArchivedTableVC:
            tableViewState = "Archived"
            initTableView(withState: tableViewState)
        
            
        case .SettingVC:
            initSettingView()
        default:
            break;
        }
        
        
    }
    
    // push data into table view's viewModel and present table view
    private func initTableView(withState tableViewType: String) {
        let toDoItemTableListStoryboard = UIStoryboard.init(name: "ItemList", bundle: nil)
        if let toDoItemTableListVC = toDoItemTableListStoryboard.instantiateInitialViewController() as? ItemTableViewController {
            
            // update main view's navigation item
            setCurrentNavigationItem(title: tableViewType)
            // load items content into table view's viewModel
            self.viewModel.pushItemsToTableView(withState: tableViewType, tableViewController: toDoItemTableListVC)
            presentCurrentViewController(currentPresented: toDoItemTableListVC)
        }

    }
    // push data into table view's viewModel and present table view
    private func initSettingView() {
        let settingStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        if let settingVC = settingStoryboard.instantiateViewController(withIdentifier: "StaticSettingController") as? StaticSettingController {
            setCurrentNavigationItem(title: "Setting")
            presentCurrentViewController(currentPresented: settingVC)
            
        }
        
    }
    
    // called by initTableView and initSettingView
    private func presentCurrentViewController(currentPresented: UITableViewController) {
        // record current table view controller
        self.selectedTable = currentPresented
        self.addChildViewController(currentPresented)
        self.subViewContainerView.addSubview(selectedTable!.tableView)
    }

    
    public func showItemTableForIndex(_ selectedIndexInMenu:Int){
        
        removeOldTableView()
        print ("showDemoControllerForIndex: selected Index: \(selectedIndexInMenu)")
    
        loadTableView(type: DestinationVCType(rawValue:  selectedIndexInMenu)!)
        
        
    }
    
    private func removeOldTableView() {
        if selectedTable != nil {
            selectedTable!.view.removeFromSuperview()
            selectedTable!.removeFromParentViewController()
            selectedTable = nil
        }
    }

   
    

    fileprivate func setCurrentNavigationItem (title: String?) {
    
        let titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:100, height: 30))
        titleLabel.text = title
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont(name: "Chalkboard SE", size: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.99, green: 0.73, blue: 0.17, alpha: 1)
     //   self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.titleView = titleLabel
        //let rightItem1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(self.rightNaviBarItemActionForItemTable1))
        let rightItem2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemTable2))
        rightItem2.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItems = [rightItem2]
        
    }
    
    
//    func rightNaviBarItemActionForItemTable1() {
//        self.viewModel.updateTableViewAction()
//    }
//       
//    
    func rightNaviBarItemActionForItemTable2() {
        
        let itemDetailStoryboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        if let itemDetailVC = itemDetailStoryboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            itemDetailVC.viewModel.currentState = .Initializing
            setNavigationControllerForItemDetail(detailView: itemDetailVC)
            self.navigationController?.pushViewController(itemDetailVC, animated: true)
        }
    }

    
    // MARK: -  pre setting for NavigationController of itemDetailViewController
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




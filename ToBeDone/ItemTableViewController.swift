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

class ItemTableViewController: UITableViewController {


    var viewModel = ItemTableViewModel.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()

        //group items into sections

        /*for i in 0..<items.count{
            print("\(items[i].title!)'s scheduled date is \(items[i].scheduledDate!)")
        }*/
        //tableView.register(UINib.init(nibName: "CollectionCellView", bundle: nil), forCellReuseIdentifier: "newTableCellTableViewCell")


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
        
        tableView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setNavigationControllerForItemDetail(detailView: UIViewController) {


        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = "New Todo!"
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        detailView.navigationItem.titleView = titleLabel

        //  let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.rightNaviBarItemActionForItemDetail))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.leftNaviBarItemActionForItemDetail))
        leftItem.tintColor = UIColor.black
        detailView.navigationItem.rightBarButtonItem = nil
        detailView.navigationItem.leftBarButtonItem = leftItem
        
    }

    func leftNaviBarItemActionForItemDetail() {
        if let itemDetailVC = self.navigationController?.viewControllers.last as? ItemDetailViewController {
            if let dropdownmenu = itemDetailVC.dropDownMenu {
                dropdownmenu.closeAllComponents(animated: true);
            }
        }
       
        self.navigationController?.popViewController(animated: true)
    }


    fileprivate func notificationCenterSetup() {
        let updateTableView = NSNotification.Name(rawValue: "updateTableView")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: updateTableView, object: nil)
        
        
    }
    
    func reloadTable() {
        self.viewModel.updateData()
        tableView.reloadData()
        
    }
}
    
    


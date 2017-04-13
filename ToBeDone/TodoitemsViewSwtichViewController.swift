//
//  TodoitemsViewSwtichViewController.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 11/27/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import RealmSwift

class TodoitemsViewSwtichViewController: UIViewController {
    
    var items: Results<TodoItem>!
    var collectionType: String?
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: ToDoItemsViewController2?

    override func viewDidLoad() {
        let toDoItemTableListStoryboard = UIStoryboard.init(name: "TodoItemTableList", bundle: nil)
        if let toDoItemTableListVC = toDoItemTableListStoryboard.instantiateInitialViewController() as?ToDoItemsViewController2 {
            toDoItemTableListVC.items = items
            toDoItemTableListVC.collectionType = collectionType
            addSubview(subView: toDoItemTableListVC.tableView, toView: self.containerView)
        }
        
        /*self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoItemsViewController2") as? ToDoItemsViewController2
            self.currentViewController?.items = self.items
            self.currentViewController?.collectionType = self.collectionType
        */
        //self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
       // self.addChildViewController(self.currentViewController!)
        //self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

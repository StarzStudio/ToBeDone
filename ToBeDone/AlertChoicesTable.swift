//
//  AlertChoicesTable.swift
//  ToBeDone
//
//  Created by 周星 on 11/15/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit



class AlertChoicesTable: UITableViewController {
    
    var selectedAlertOption : String?
    
    let alertOptions = ["At time of event",
                        "5 minutes before",
                        "15 minutes before",
                        
                        "1 hour before",
                        
                        "1 day before"]
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func viewDidLoad() {
        let cellNib = UINib(nibName: "AlertChoicesTableCell", bundle: Bundle.main)
        self.tableView.register(cellNib, forCellReuseIdentifier: "AlertChoicesTableCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertOptions.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertChoicesTableCell",
                                                 for: indexPath) as! AlertChoicesTableCell
        
        
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
      
        cell.alertTimeLabel.text = alertOptions[(indexPath as NSIndexPath).row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectedAlertOption = alertOptions[(indexPath as NSIndexPath).row]
        
    }
}

//
//  userDetailsViewController.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 12/5/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class userDetailsViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var userInfoRef: FIRDatabaseReference!
    var userInfo = [String: String]()
    

    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Setting", style: UIBarButtonItemStyle.done, target: self, action: #selector(userDetailsViewController.goBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Your Details"
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")

        
        let item1 = TodoItem()
        item1.title = "item1_InBox"
        item1.modifiedDate = item1.createdDate
        FirebaseUtility.addItemToFirebase(with: item1)
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 80))//create a tableFooterView
        
        print("setting view load")
        
        ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            userInfoRef = self.ref.child("Users/\(user.uid)/info")
            userInfoRef.observeSingleEvent(of: .value, with: {(snapShot) in
                self.userInfo = snapShot.value as? NSDictionary as! [String: String]
        })
        }
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        /*header.textLabel?.font = UIFont(name: "Futura", size: 38)!
         header.textLabel?.textColor = UIColor.white
         let header = view as! UITableViewHeaderFooterView
         header.textLabel?.textColor = UIColor(red: 243/255, green: 153/255, blue: 193/255, alpha: 1.0)
         header.textLabel?.font = UIFont(name: "Helvetica Neue", size: 18)
         header.textLabel?.text = "About Us"
         header.textLabel?.frame = header.frame
         header.textLabel?.textAlignment = NSTextAlignment.left*/
        
        header.backgroundView?.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.backgroundView?.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {//number of section
        
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//section's title
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//load data into each row
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        switch indexPath.row {
        case 0:
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath) as! ProfileCell
            return profileCell
        case 1:
            cell.textLabel?.text = "User Name"
            cell.detailTextLabel?.text = self.userInfo["userName"]
        case 2:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = self.userInfo["userEmail"]
        case 3:
            cell.textLabel?.text = "Change Your Password"
        default:
            break
        }
        return cell
    }
    
}

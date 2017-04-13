//
//  StaticSettingController.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 11/10/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Toast_Swift

class StaticSettingController: UITableViewController {
    @IBOutlet var backGroundImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet weak var logInCellTitle: UILabel!
    

    let defaultBackgroundImage = UIImage(named: "Setting_Background_Image")! as UIImage
    let defaultUserProfileImage = UIImage(named: "Default_Profile_Image")! as UIImage
    let defaultUserName = "User Name"
    
    var backGroundImage: UIImage!
    var userProfileImage: UIImage!
    var userName: String!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let item1 = TodoItem()
        item1.title = "item1_InBox"
        item1.modifiedDate = item1.createdDate
        FirebaseUtility.addItemToFirebase(with: item1)
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 80))//create a tableFooterView
        
          print("setting view load")
    }
    
    override func viewWillAppear(_ animated: Bool){
        if let user = FIRAuth.auth()?.currentUser {//user signed in
            self.ref = FIRDatabase.database().reference()
            let userNameRef = self.ref.child("Users/\(user.uid)/info/userName")
            
            userNameRef.observeSingleEvent(of: .value, with: {(snapShot) in
                let userName = snapShot.value as? String
                self.userNameLabel.text = userName
                self.logInCellTitle.text = "Sign out"
            })
            //userNameLabel.text = AppState.sharedInstance.displayName
            
            
        }
        else{
            initDefaultSettings()
            logInCellTitle.text = "Sign in"
        }
    }
    
    func initDefaultSettings() {
        userNameLabel.text = "User Name"
        backGroundImageView.image = defaultBackgroundImage
        userProfileImageView.image = defaultUserProfileImage
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      print("setting view appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("setting view disappear")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        switch (indexPath.section) {
        case 0://section 0
            switch (indexPath.row) {
            case 0://your details
               didSelectDetails()
            case 1://notifications
                break
            case 2:// sign out
               didSelectSignOut()
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                didTapCleanData()
            default:
                break
            }
        default:
            break
        }
    }
    
    func didSelectDetails() {
        if FIRAuth.auth()?.currentUser != nil {//user is signed in
            gotoDetails()
        }
        else{//no user is signed in
            gotoSignIn()
        }
    }
    
    func gotoDetails() {
        //let userDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetails") as! userDetailsViewController
        
        if let userDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetails") as? userDetailsViewController {
            
            let navController = UINavigationController(rootViewController: userDetailsViewController)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    func gotoSignIn()  {
        let signInStoryBoard = UIStoryboard.init(name: "SignIn", bundle: nil)
        
        
        if let SignInViewController = signInStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            
            let navController = UINavigationController(rootViewController: SignInViewController) // Creating a navigation controller with SignInViewController at the root of the navigation stack.
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    func didSelectSignOut()  {
        
        
        if FIRAuth.auth()?.currentUser != nil{
            let prompt = UIAlertController.init(title: "Sign out?", message: "Are you sure?", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "Yes", style: .default, handler: {(action) in
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    AppState.sharedInstance.signedIn = false
                    self.logInCellTitle.text = "Sign in"
                    self.view.makeToast("You have logged out successfully!")
                    self.initDefaultSettings()
                } catch let signOutError as NSError {
                    self.view.makeToast("Error signing out: \(signOutError.localizedDescription)")
                }})
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            prompt.addAction(yesAction)
            prompt.addAction(cancelAction)
            present(prompt, animated: true, completion: nil)
        }
        else{
            self.view.makeToast("No user is signed in.")
            gotoSignIn()
        }
        
        
    }
    
    func didTapCleanData() {
        if FIRAuth.auth()?.currentUser != nil{
            let prompt = UIAlertController.init(title: "Clean Data?", message: "This will remove your data from both local and remote.", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "Yes", style: .default, handler: {(action) in
                    FirebaseUtility.removeDatabaseFromFirebase()
                })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            prompt.addAction(yesAction)
            prompt.addAction(cancelAction)
            present(prompt, animated: true, completion: nil)
        }
        else{
            self.view.makeToast("No user is signed in.")
            gotoSignIn()
        }
    }
    
    
  }

//
//  SignInViewController.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 12/3/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Toast_Swift
import FirebaseDatabase

class SignInViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    fileprivate var errorMessage = ""
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add back button to navigation bar
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(SignInViewController.goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signIn()
        textField.resignFirstResponder()
        return true
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
         view.endEditing(true)
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        signIn()
    }
    
    func signIn() {
        view.endEditing(true)
        
        guard let email = emailTextField.text, let password = passwordField.text else { return }
            
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                //print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.view.makeToast(self.errorMessage)
                return
            }
            self.signedIn(user!)
          //  FirebaseService.syncData()
            
            
        }
    }
    
    func signedIn(_ user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        //let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        goBack()
        
    }
    
    @IBAction func didTapResetPassword(_ sender: UIButton) {
        view.endEditing(true)
        
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    //print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.view.makeToast(self.errorMessage)
                    
                }
                else{
                    self.view.makeToast("An email with reset information has been sent to your email \(userInput!)")
                }
                return
            }
            
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        prompt.addAction(cancelAction)
        present(prompt, animated: true, completion: nil);

    }
    
    @IBAction func didTapCreateAccount(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let email = emailTextField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                //print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.view.makeToast(self.errorMessage)
                return
            }
            self.setDisplayName(user!)
        }
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.view.makeToast(self.errorMessage)
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
        //add info to remote database
        self.ref = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            let userInfo = self.ref.child("Users/\(user.uid)/info")
            userInfo.setValue(["userName" : changeRequest.displayName!, "userEmail": user.email!, "profileImageURL": AppState.sharedInstance.photoURL ?? "" as Any,])
        }
    }
    
    
    func postError() {
        errorLabel.text = errorMessage
    }
}



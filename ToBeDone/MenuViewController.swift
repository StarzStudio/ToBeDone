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




class MenuViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate  {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    
    let DismissSegueName = "DismissMenuSegue"

    var menuItemIndex : Int?
    
    var viewModel = MenuViewModel.sharedInstance
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    
    
    
    
   
    
   //let mainColor = UIColor(hex: 0xC4ABAA)
    let mainColor = UIColor.flatWhite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBar.tintColor              = .black
        topBar.barTintColor           = mainColor
        topBar.titleTextAttributes    = [
            NSFontAttributeName: UIFont(name: "Marker Felt", size: 22)!,
            NSForegroundColorAttributeName: UIColor.flatBlack
        ]
        userTableView.backgroundColor = mainColor
        view.backgroundColor          = mainColor
        
        viewModel.updateMenuList()
        
       
        
        
    }
      
    // MARK: - Managing the Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UITableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
        
        let menuItem = viewModel.menuList[(indexPath as NSIndexPath).row]
        
        cell.menuItemName.text = menuItem.name
        cell.menuItemImageView.image =  menuItem.image
        if menuItem.unfinishedNum == 0 {
            cell.unfinishedNumLabel.isHidden  = true
        } else {
             cell.unfinishedNumLabel.isHidden  = false
             cell.unfinishedNumLabel.text = menuItem.unfinishedNum?.description
            // if this is today item, set number's color to red
            if (indexPath as NSIndexPath).row == 1 {
                 cell.unfinishedNumLabel.textColor = UIColor.red
            }
        }
    
        cell.contentView.backgroundColor = mainColor
        
        return cell
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Debug.log(message: "Select row at \(indexPath)")
        
        menuItemIndex = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: DismissSegueName, sender: self)
     
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let mainViewController = segue.destination as! MainViewController
        if let index = menuItemIndex {
              mainViewController.showItemTableForIndex(index)
        }
      


    }



}

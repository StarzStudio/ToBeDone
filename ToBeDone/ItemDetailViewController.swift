//
//  ItemDetailViewController.swift
//  2BDone
//
//  Created by 周星 on 10/20/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SnapKit
import AFDateHelper
import IGListKit
import MKDropdownMenu
import ChameleonFramework
import ExpandingMenu
import RKTagsView
import FlatUIKit


class ItemDetailViewController : UIViewController{
    // MARK: @IBOutlet
    @IBOutlet weak var tagList_TagsView : RKTagsView!
    @IBOutlet weak var itemNote_TextView : FloatLabelTextView!
   // @IBOutlet weak var images_CollectionView: UICollectionView!
    @IBOutlet weak var location_Button : imgLeftTitleRightButton!
    @IBOutlet weak var subTasks_Table: UITableView!
    @IBOutlet weak var confirm_Button : UIButton!
    @IBOutlet weak var itemTitle_TextField: FloatLabelTextField!
    @IBOutlet weak var dueDate_Label: UILabel!
    @IBOutlet weak var alertTime_Label: UILabel!
    @IBOutlet weak var dueDate_ImageView: UIImageView!
    @IBOutlet weak var alertTime_ImageView: UIImageView!
    
    
    // MARK: - property
    
    
    
    // MARK: - tool menu
    
    fileprivate func setToolButton () {
        
    }
    
    
    
    //var toolButton: FabButton!
    
    var pickedTime : String?
    var alertDate : Date?
    var datePicker = DatePickerDialog()
    var alertView = AlertView()
   
    var mapView = MapViewController()
    
    
    var dropDownMenu : MKDropdownMenu!
    var dateTimeButton: UIButton!
    var alertButton: UIButton!
    var addPictureButton: UIButton!
    var dateTimeImage : UIImageView!
    var alertImage : UIImageView!
    var addPhotoImage : UIImageView!
    
    var rowItems = Array<Any>()
    
    
    
    
    var viewModel = ItemDetailViewModel.sharedInstance
    


    // MARK: - Life cycle

    override func viewDidLoad() {
        Debug.log(message: "item view load")
        super.viewDidLoad()
        
        setTagList()
        setItemTitle()
        setItemNote()
        setLocationButton()
        self.location_Button.isHidden = true
        setDropDownMenu()
      
        setHidedItems()
        setConfirmBotton()
        
        notificationCenterSetup()
        
        switch viewModel.currentState {
        case .Modifing:
            updateItemDetailViewContent()
        case .Initializing:
            viewModel.clean()
        }
        
    }
    

    fileprivate func setConfirmBotton(){
        self.confirm_Button.setImage(UIImage(named:"confirmButton_itemDetail"), for: UIControlState.normal)
        self.confirm_Button.imageView?.contentMode = .scaleAspectFit
        self.confirm_Button.addTarget(self,
                                      action: #selector(self.tapConfirmButton(_:)),
                                      for: UIControlEvents.touchUpInside )
        self.view.addSubview(self.confirm_Button)
    }

    func tapConfirmButton (_ sender:UIButton) {
        
        
        // Debug.log(message: "confirm button tapped")
        
        
        // set notification if alert date has been set
        if let alertDate = self.alertDate {
            NotificationService.addLocalNotification(with: viewModel.item.alertDate!, on: alertDate)
        }
        
        // call end text editing for text field and text view
        textViewDidEndEditing(self.itemNote_TextView)
        textFieldDidEndEditing(self.itemTitle_TextField)
        
        
        // store tags:
        viewModel.item.tags = self.tagList_TagsView.tags;
        
        
        if notify() == true {
            
            self.navigationController?.popViewController(animated: true)
            self.viewModel.updateTableViewAction()

        }
        
    }
    

    
    

    fileprivate func notificationCenterSetup() {
        let pinSwitchOn = NSNotification.Name(rawValue:"pinSwitchOn")
        
        NotificationCenter.default.addObserver(self, selector:#selector(unHideLocatonButton), name: pinSwitchOn, object: nil)
        
        let pinSwitchOff = NSNotification.Name(rawValue:"pinSwitchOff")
        
        NotificationCenter.default.addObserver(self, selector:#selector(hiderLocatonButton), name: pinSwitchOff, object: nil)
        
        
    }
    
    func unHideLocatonButton(notification:NSNotification) {
        self.location_Button.isHidden = false
    }
    
    func hiderLocatonButton(notification:NSNotification) {
        self.location_Button.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Debug.log(message: "detail view disappear")
    }
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
       //   setConstraint()
        print("detail view appear")
        
        if let dropDownMenu = dropDownMenu {
             dropDownMenu.closeAllComponents(animated: true)
        }
        
        
    }
    // MARK: - Setting
            // MARK: location
    
    func setLocationButton () {
        
        var placeName = self.viewModel.defaultPlaceContent
        let locationButtonImg = UIImage(named: "Location_ItemDetail")
        self.location_Button.setTitle(newTitle: placeName)
        self.location_Button.setImg(newImg: locationButtonImg)
        self.location_Button.addTarget(self, action: #selector(self.tapLocationButton) , for: .touchUpInside)
        
        weak var weakSelf = self
        
        self.viewModel.getLocationCentent() { (placeName) -> Void in
            // if user switch back to the table view before the location update, then self will be nil.
            if let validWeakSelf = weakSelf {
                validWeakSelf.location_Button.setTitle(newTitle: placeName)
            }

        }
        
        
    }
    
    func tapLocationButton () {
        // show popover view
        //        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        //        let options = [
        //            .type(.up),
        //            .animationIn(0.3)
        //            ] as [PopoverOption]
        //        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        //
        //        popover.show(aView, fromView: self.locationButton)
        
        weak var weakSelf = self
        self.viewModel.getCurrentCLLocation() { (cllocation) -> Void in
            weakSelf!.mapView.location = cllocation
            if let navi = self.navigationController {
                navi.pushViewController(weakSelf!.mapView, animated: true)
                
            }
        }
    }

    
     // MARK: tag
   
    func setTagList () {
        self.tagList_TagsView.removeAllTags()
        self.tagList_TagsView.textField.placeholder = self.viewModel.defaultTagsContent
        self.tagList_TagsView.textField.returnKeyType = .done
        self.tagList_TagsView.textField.delegate = self
        self.tagList_TagsView.textField.font = UIFont.init(name: "HelveticaNeue-Bold", size: 14)
        self.tagList_TagsView.textField.textAlignment = .left
        self.tagList_TagsView.textField.backgroundColor = UIColor.white
        self.tagList_TagsView.textField .textColor = .flatBlack
        self.tagList_TagsView.textField.borderStyle = .roundedRect
        self.tagList_TagsView.editable = true
        self.tagList_TagsView.selectable = true
        self.tagList_TagsView.allowsMultipleSelection = true
        self.tagList_TagsView.interitemSpacing = 4
        self.tagList_TagsView.lineSpacing = 2
        self.tagList_TagsView.font = UIFont.boldSystemFont(ofSize: 14)
        //tagList.delegate = self
    
        self.tagList_TagsView.reloadButtons()
        
        self.view.addSubview(self.tagList_TagsView)
        
    }

  
    
     // MARK: Title
    func setItemTitle (){
        self.itemTitle_TextField.placeholder = self.viewModel.defaultTitleContent
        self.itemTitle_TextField.clearButtonMode = .whileEditing
        self.itemTitle_TextField.textAlignment = NSTextAlignment.left
        self.itemTitle_TextField.allowsEditingTextAttributes = true
        self.itemTitle_TextField.textColor = UIColor.darkGray
        self.itemTitle_TextField.titleTextColour = UIColor.darkGray
        self.itemTitle_TextField.titleActiveTextColour = UIColor.darkGray
        self.itemTitle_TextField.backgroundColor = UIColor.clear
        self.itemTitle_TextField.font = UIFont.init(name: "HelveticaNeue-Bold", size: 14)
        self.itemTitle_TextField.returnKeyType = UIReturnKeyType.done
        self.itemTitle_TextField.autocorrectionType = UITextAutocorrectionType.yes
        self.itemTitle_TextField.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.itemTitle_TextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.itemTitle_TextField.delegate = self
        self.view.addSubview(self.self.itemTitle_TextField)
    }
    
    // MARK: Note
    func setItemNote () {
        self.itemNote_TextView.hint = self.viewModel.defaultNoteContent
        self.itemNote_TextView.textAlignment = NSTextAlignment.left
        self.itemNote_TextView.allowsEditingTextAttributes = true
        self.itemNote_TextView.textColor = UIColor.darkGray
        self.itemNote_TextView.titleTextColour = UIColor.darkGray
        self.itemNote_TextView.titleActiveTextColour = UIColor.darkGray
        self.itemNote_TextView.backgroundColor = UIColor.clear
        self.itemNote_TextView.font = UIFont.init(name: "HelveticaNeue-Bold", size: 14)
        self.itemNote_TextView.returnKeyType = UIReturnKeyType.done
        self.itemNote_TextView.autocorrectionType = UITextAutocorrectionType.yes
        self.itemNote_TextView.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.itemNote_TextView.keyboardAppearance = UIKeyboardAppearance.dark
        self.itemNote_TextView.delegate = self
        self.itemNote_TextView.layer.cornerRadius  = 4.0

        self.view.addSubview(self.itemNote_TextView)
        
    }


    // MARK: hided items
    fileprivate func setHidedItems (){
        self.dueDate_Label.isHidden = true
        self.alertTime_Label.isHidden = true
        self.dueDate_ImageView.isHidden = true
        self.alertTime_ImageView.isHidden = true
    }
   
       
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.itemTitle_TextField.isFirstResponder  == true {
            self.itemTitle_TextField.resignFirstResponder()
        }
        if self.itemNote_TextView.isFirstResponder == true {
            self.itemNote_TextView.resignFirstResponder()
        }
    }
    
    
    
    
    func updateItemDetailViewContent() {
        let itemDTO = self.viewModel.item
        itemTitle_TextField.text = itemDTO.title
        itemNote_TextView.text = itemDTO.note
        if let scheduleDate = itemDTO.scheduledDate {
            self.dueDate_Label.isHidden = false
            self.dueDate_ImageView.isHidden = false
            self.dueDate_Label.text = scheduleDate

        }
        
        if let alertDate = itemDTO.alertDate {
            self.alertTime_Label.isHidden = false
            self.alertTime_ImageView.isHidden = false
            self.alertTime_Label.text = alertDate
            
        }
        for tag in viewModel.item.tags {
            self.tagList_TagsView.addTag(tag)
        }
        
        
        //            for image in viewModel.item.images.values {
        //
        //                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        //                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        //                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        //                if let dirPath          = paths.first
        //                {
        //                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageView.imageId)
        //                    let image    = UIImage(contentsOfFile: imageURL.path)
        //                    IGListData.append(IGListImageModel(image: image))
        //                    adapter.performUpdates(animated: true, completion: nil)
        //                
        //            }
   
    }
    
}






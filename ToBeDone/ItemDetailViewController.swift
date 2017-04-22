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


class ItemDetailViewController : UIViewController, IGListAdapterDataSource{
    // MARK: @IBOutlet
    @IBOutlet weak var tagList_TagsView : RKTagsView!
    @IBOutlet weak var itemNote_TextView : FloatLabelTextView!
    @IBOutlet weak var IGListImageSet_CollectionView: IGListCollectionView!
    @IBOutlet weak var location_Button : imgLeftTitleRightButton!
    @IBOutlet weak var subTasks_Table: UITableView!
    @IBOutlet weak var confirm_Button : UIButton!
    @IBOutlet weak var itemTitle_TextField: FloatLabelTextField!
    @IBOutlet weak var dueDate_Label: UILabel!
    @IBOutlet weak var alertTime_Label: UILabel!
    @IBOutlet weak var dueDate_ImageView: UIImageView!
    @IBOutlet weak var alertTime_ImageView: UIImageView!
    
    
    // MARK: - property
    
    var IGListData : [IGListImageModel]! = [IGListImageModel(image:UIImage())]
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var imageURLs:[String]?
    
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
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    var rowItems = Array<Any>()
    
    
    
    
    var viewModel = ItemDetailViewModel.sharedInstance {
        didSet {
            initializeAllfieldsData()
        }
    }
    
    fileprivate func initializeAllfieldsData() {
        self.itemNote_TextView.text = viewModel.item.note
        self.itemTitle_TextField.text =  viewModel.item.title
        if let date = viewModel.item.scheduledDate {
            self.dueDate_Label.text = date
            self.dueDate_Label.isHidden = false
            self.dueDate_ImageView.isHidden = false
        }
        
        if let date = viewModel.item.alertDate {
            self.alertTime_Label.text = date
            self.alertTime_Label.isHidden = false
            self.alertTime_ImageView.isHidden = false
        }
        
        if let tags = viewModel.item.tags {
            for tag in tags {
                self.tagList_TagsView.addTag(tag)
            }
        }
        
        
        if let images = viewModel.item.images {
            for image in images {
                
//                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//                if let dirPath          = paths.first
//                {
//                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageView.imageId)
//                    let image    = UIImage(contentsOfFile: imageURL.path)
                    IGListData.append(IGListImageModel(image: image))
                    adapter.performUpdates(animated: true, completion: nil)
                
            }
        }
    }
    

    // MARK: - Life cycle

    override func viewDidLoad() {
        Debug.log(message: "item view load")
        super.viewDidLoad()
        
        setTagList()
        setItemTitle()
        setItemNote()
        setLocationButton()
        setDropDownMenu()
        setIGListCollectionView()
        setIGListDataForTest()
        setHidedItems()
        setConfirmBotton()
        
        notificationCenterSetup()
        
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
        Debug.log(message: "confirm button tapped")
        
        
        // set notification if alert date has been set
        if let alertDate = self.alertDate {
            NotificationService.addLocalNotification(with: viewModel.item.alertDate!, on: alertDate)
        }
        
        // store tags:
        viewModel.item.tags = self.tagList_TagsView.tags;
        
        
        notify()
        
        self.navigationController?.popViewController(animated: true)
        updateTableViewAction()
    }
    

    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
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
    
    
    
    fileprivate func setIGListDataForTest () {
        let image1 = UIImage(named: "shoppingList1_Test")!
        let image2 = UIImage(named: "shoppingList2_Test")!
        let image3 = UIImage(named: "memo_Test")!
        IGListData.append(IGListImageModel(image: image1))
        IGListData.append(IGListImageModel(image: image2))
        IGListData.append(IGListImageModel(image: image3))
        adapter.performUpdates(animated: true, completion: nil)
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
            weakSelf!.location_Button.setTitle(newTitle: placeName)
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
        self.tagList_TagsView.textField.font = UIFont.boldSystemFont(ofSize: 15)
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
        self.itemTitle_TextField.backgroundColor = UIColor.clear
        self.itemTitle_TextField.font = UIFont.boldSystemFont(ofSize: 15)
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
        self.itemNote_TextView.backgroundColor = UIColor.flatWhite
        self.itemNote_TextView.font = UIFont.boldSystemFont(ofSize: 18)
        self.itemNote_TextView.returnKeyType = UIReturnKeyType.done
        self.itemNote_TextView.autocorrectionType = UITextAutocorrectionType.yes
        self.itemNote_TextView.autocapitalizationType = UITextAutocapitalizationType.sentences
        self.itemNote_TextView.keyboardAppearance = UIKeyboardAppearance.dark
        self.itemNote_TextView.delegate = self
        self.itemNote_TextView.layer.cornerRadius  = 4.0
        self.view.addSubview(self.itemNote_TextView)
        
    }

    // MARK: IGList image set
    
   
   
    fileprivate func setIGListCollectionView () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
    //    layout.sectionInset = UIEdgeInsetsMake(3, 5, 3, 5)
        self.IGListImageSet_CollectionView.alwaysBounceVertical = false
        self.IGListImageSet_CollectionView.alwaysBounceHorizontal = true
        self.IGListImageSet_CollectionView.collectionViewLayout = layout
        self.IGListImageSet_CollectionView.allowsSelection = true
        adapter.collectionView = self.IGListImageSet_CollectionView
        adapter.dataSource = self
        
    }
    

    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        // this can be anything!
        return IGListData!
    
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {

        return IGListImageSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: hided items
    fileprivate func setHidedItems (){
        self.dueDate_Label.isHidden = true
        self.alertTime_Label.isHidden = true
        self.dueDate_ImageView.isHidden = true
        self.alertTime_ImageView.isHidden = true
    }
   
       // MARK: confirm Button
    
}






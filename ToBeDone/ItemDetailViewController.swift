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
import TagListView
import SwiftMessages
import SnapKit
import AFDateHelper
import IGListKit
import MobileCoreServices
import Photos
import PhotosUI
import AssetsLibrary
import ChameleonFramework
import ExpandingMenu
import RKTagsView
import MKDropdownMenu
import FlatUIKit


class ItemDetailViewController : UIViewController, IGListAdapterDataSource{
    
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
    
    var itemState : ItemState
    let locationManager = LocationManager.sharedInstance
    var mapView = MapViewController()
    var isNewAddingItem = true
    
    var dropDownMenu : MKDropdownMenu!
    var dateTimeButton: UIButton!
    var alertButton: UIButton!
    var addPictureButton: UIButton!
    var dateTimeImage : UIImageView!
    var alertImage : UIImageView!
    var addPhotoImage : UIImageView!
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    var rowItems = Array<Any>()
    
    
    
    // MARK: @IBOutlet
 
    @IBOutlet weak var tagList : RKTagsView!
    @IBOutlet weak var itemNote : FloatLabelTextView!
    @IBOutlet weak var IGListImageSet: IGListCollectionView!
    @IBOutlet weak var locationButton : imgLeftTitleRightButton!
    @IBOutlet weak var subTasksTable: UITableView!
    @IBOutlet weak var confirmBotton : UIButton!
    @IBOutlet weak var itemTitle: FloatLabelTextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    @IBOutlet weak var dueDateImage: UIImageView!
    @IBOutlet weak var alertTimeImage: UIImageView!
    // MARK: - Life cycle

    override func viewDidLoad() {
        
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
        if isNewAddingItem == false {
            initializeAllfieldsData()
        }
      //  initExpandableIcons()
        
        print("item view load")
        notificationCenterSetup()
        
    }
    
    fileprivate func notificationCenterSetup() {
        let pinSwitchOn = NSNotification.Name(rawValue:"pinSwitchOn")
        
        NotificationCenter.default.addObserver(self, selector:#selector(unHideLocatonButton), name: pinSwitchOn, object: nil)
        
        let pinSwitchOff = NSNotification.Name(rawValue:"pinSwitchOff")
        
        NotificationCenter.default.addObserver(self, selector:#selector(hiderLocatonButton), name: pinSwitchOff, object: nil)
        
    }
    
    func unHideLocatonButton(notification:NSNotification) {
        self.locationButton.isHidden = false
    }
    
    func hiderLocatonButton(notification:NSNotification) {
        self.locationButton.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("detail view disappear")
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
        
        var placeName = ""
        let locationButtonImg = UIImage(named: "Location_ItemDetail")
        locationButton.setTitle(newTitle: placeName)
        locationButton.setImg(newImg: locationButtonImg)
        locationButton.addTarget(self, action: #selector(self.tapLocationButton) , for: .touchUpInside)
        
        weak var weakSelf = self
        locationManager.getCurrentPlaceName(placeNameDisplayMode: .concise) { (generatedPlaceName) -> Void in
           
            if let placeName = generatedPlaceName {
                weakSelf!.locationButton.setTitle(newTitle: placeName)
                // weakSelf!.locationButton.setTitle(newTitle: "Syracuse")
                weakSelf!.itemState.itemLocation = placeName
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
        
        locationManager.getCurrentCLLocation() { (cllocation) -> Void in
            
            weakSelf!.mapView.location = cllocation!
            if let navi = self.navigationController {
                navi.pushViewController(weakSelf!.mapView, animated: true)
                
            }
        }
    }

    
     // MARK: tag
   
    func setTagList () {
        self.tagList.removeAllTags()
        self.tagList.textField.placeholder = "Add tag..."
        self.tagList.textField.returnKeyType = .done
        self.tagList.textField.delegate = self
        self.tagList.textField.font = UIFont.boldSystemFont(ofSize: 15)
        self.tagList.textField.textAlignment = .left
        self.tagList.textField.backgroundColor = UIColor.white
        self.tagList.textField .textColor = .flatBlack
        self.tagList.textField.borderStyle = .roundedRect
        tagList.editable = true
        tagList.selectable = true
        tagList.allowsMultipleSelection = true
        tagList.interitemSpacing = 4
        tagList.lineSpacing = 2
        
        tagList.font = UIFont.boldSystemFont(ofSize: 14)
        //tagList.delegate = self
    
        tagList.reloadButtons()
        
        self.view.addSubview(tagList)
        
    }
    
//    func setAddTagButton() {
//        
//        addTagButton.setImage(UIImage(named: "addTag_itemDetail"), for: UIControlState.normal)
//        addTagButton.imageView?.contentMode = .scaleAspectFit
//        
//        addTagButton.addTarget(self, action: #selector(self.tapAddTagButton) , for: .touchUpInside)
//        
//    }
    
  
    
     // MARK: Title
    func setItemTitle (){
        
        itemTitle.placeholder = "title..."
        itemTitle.clearButtonMode = .whileEditing
        itemTitle.textAlignment = NSTextAlignment.left
        itemTitle.allowsEditingTextAttributes = true
        itemTitle.textColor = UIColor.darkGray
        itemTitle.backgroundColor = UIColor.clear
        itemTitle.font = UIFont.boldSystemFont(ofSize: 15)
        itemTitle.returnKeyType = UIReturnKeyType.done
        itemTitle.autocorrectionType = UITextAutocorrectionType.yes
        itemTitle.autocapitalizationType = UITextAutocapitalizationType.sentences
        itemTitle.keyboardAppearance = UIKeyboardAppearance.dark
        itemTitle.delegate = self
        self.view.addSubview(itemTitle)


    }
    
    // MARK: Note
    func setItemNote () {
       

        itemNote.hint = "Note..."
        self.view.addSubview(itemNote)
        itemNote.textAlignment = NSTextAlignment.left
        itemNote.allowsEditingTextAttributes = true
        itemNote.textColor = UIColor.darkGray
        itemNote.backgroundColor = UIColor.flatWhite
        itemNote.font = UIFont.boldSystemFont(ofSize: 18)
        itemNote.returnKeyType = UIReturnKeyType.done
        itemNote.autocorrectionType = UITextAutocorrectionType.yes
        itemNote.autocapitalizationType = UITextAutocapitalizationType.sentences
        itemNote.keyboardAppearance = UIKeyboardAppearance.dark
        itemNote.delegate = self
        itemNote.layer.cornerRadius  = 4.0
        
        
    }

    // MARK: IGList image set
    
   
   
    fileprivate func setIGListCollectionView () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
    //    layout.sectionInset = UIEdgeInsetsMake(3, 5, 3, 5)
        IGListImageSet.alwaysBounceVertical = false
        IGListImageSet.alwaysBounceHorizontal = true
        IGListImageSet.collectionViewLayout = layout
        IGListImageSet.allowsSelection = true
        adapter.collectionView = IGListImageSet
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
        self.dueDateLabel.isHidden = true
        alertTimeLabel.isHidden = true
        dueDateImage.isHidden = true
        alertTimeImage.isHidden = true
    }
   

    
    
    
       // MARK: confirm Button
    
    fileprivate func setConfirmBotton(){
   
        confirmBotton.setImage(UIImage(named:"confirmButton_itemDetail"), for: UIControlState.normal)
        confirmBotton.imageView?.contentMode = .scaleAspectFit
        confirmBotton.addTarget(self, action: #selector(self.tapConfirmButton(_:)), for: UIControlEvents.touchUpInside )
        self.view.addSubview(confirmBotton)
    }

    func tapConfirmButton (_ sender:UIButton) {
        print("confirm button tapped")
        if item.title == "" {
            alarmEmptyTextField(body: "Oops : ( , note area is not allowed blank")
            return
        }
        self.confirmAddingItemToDB()
    }
    
  
    
//    func setConstraint(){
//        let superview = self.view.superview!
//        let addTagButton = self.addTagButton!
//        let newTagContent = self.newTagContent!
//        let tagList = self.tagList!
//        let itemNote = self.itemNote!
//        let subTasksTable = self.subTasksTable!
//        let dateTimeButton = self.dateTimeButton!
//        let alertButton = self.alertButton!
//        let locationButton = self.locationButton!
//        
//        addTagButton.snp.makeConstraints { make in
//           make.top.equalTo(superview.snp.top).offset(20)
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(newTagContent.snp.left).offset(-8)
//            make.bottom.equalTo(tagList.snp.top).offset(-8)
//            make.size.equalTo(CGSize(width: 20, height: 20))
//        }
//        
//        newTagContent.snp.makeConstraints { make in
//            make.top.equalTo(superview.snp.top).offset(20)
//            make.right.equalTo(superview.snp.right).offset(-8)
//            make.bottom.equalTo(tagList.snp.top).offset(-8)
//            make.height.equalTo(20)
//        }
//
//        tagList.snp.makeConstraints {make in
//            make.top.equalTo(addTagButton.snp.bottom).offset(8)
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//           make.bottom.equalTo(itemNote.snp.top).offset(-8)
//            make.height.equalTo(30)
//        }
        
//        itemNote.snp.makeConstraints { make in
//            make.top.equalTo(tagList.snp.bottom).offset(8)
//
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//                make.bottom.equalTo(subTasksTable.snp.top).offset(-8)
//             make.height.equalTo(40)
//        
//        }
//
//        subTasksTable.snp.makeConstraints { make in
//             make.top.equalTo(itemNote.snp.bottom).offset(8)
//
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//            make.bottom.equalTo(dateTimeButton.snp.top).offset(-8)
//            make.height.equalTo(20)
//        }
//        
//        dateTimeButton.snp.makeConstraints { make in
//            make.top.equalTo(subTasksTable.snp.bottom).offset(8)
//
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//                make.bottom.equalTo(alertButton.snp.top).offset(-8)
//            make.height.equalTo(20)
//        }
//
//        alertButton.snp.makeConstraints {make in
//            make.top.equalTo(dateTimeButton.snp.bottom).offset(8)
//
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//                make.bottom.equalTo(locationButton.snp.top).offset(-8)
//            make.height.equalTo(40)
//        }
//        
//        locationButton.snp.makeConstraints { make in
//            make.top.equalTo(alertButton.snp.bottom).offset(8)
//
//            make.left.equalTo(superview.snp.left).offset(8)
//            make.right.equalTo(superview.snp.right).offset(-8)
//            make.bottom.equalTo(superview.snp.top).offset(80)
//            make.height.equalTo(40)
//        }
//        
        
//}
   
}


// MARK: - Delegate
extension ItemDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func triggerPictureAlubm (){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        self.dropDownMenu.closeAllComponents(animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = info["UIImagePickerControllerMediaType"] as! String
        if type  == (kUTTypeImage as String)  {
            let fetchedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
           updateIGListDataSource(image: fetchedImage)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateIGListDataSource (image:UIImage) {
        let IGListimageModel = IGListImageModel(image: image)
        IGListData.append(IGListimageModel)
        adapter.performUpdates(animated: true, completion: nil)
        
        // update db
        storeImageToDB(image: image)
        
        
    }
    
    fileprivate func storeImageToFile(image: UIImage, imageName: String) -> String?{
        if let data = UIImagePNGRepresentation(image) {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageName = imageName
            let destinationPath = documentsURL.appendingPathComponent(imageName)
            try? data.write(to: destinationPath)
            return destinationPath.absoluteString
        }
        else { return nil }
        
    }
    
    fileprivate func storeImageToDB(image: UIImage) {
        
        let dbImageModel = ImageFile()
        let imageName = dbImageModel.imageId
        dbImageModel.fileURL = storeImageToFile(image: image, imageName: imageName)
        dbImageModel.itemId = item.id
        if isNewAddingItem == true {
            item.images.append(dbImageModel)
        }
        else {
            try! db.write {
                item.images.append(dbImageModel)
            }
        }

        
    }
    
    
    
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.itemTitle.isFirstResponder  == true {
            self.itemTitle.resignFirstResponder()
        }
        if self.itemNote.isFirstResponder == true {
            self.itemNote.resignFirstResponder()
        }
    }
    
    
}


extension ItemDetailViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.itemTitle {
            if self.itemTitle.text == "" {
                alarmEmptyTextField(body: "title shouldn't be empty")
            }
            
            if isNewAddingItem == true {
                item.title = textField.text
            }
            else {
                try! db.write {
                item.title = textField.text
                }
            }
        }
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
            if string == "\n" {
                textFieldDidEndEditing(textField)
                return false
            }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}


extension ItemDetailViewController: UITextViewDelegate {
    
     func textViewDidEndEditing(_ textView: UITextView) {
        
        self.itemNote.resignFirstResponder()
        if isNewAddingItem == true {
            item.note = textView.text
        }
        else {
            try! db.write {
                item.note = textView.text
            }
        }
    }
    
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textViewDidEndEditing(textView)
            return false
        }
        
        return true
        
        
    }
}



extension ItemDetailViewController: RKTagsViewDelegate {
    func tagsView(_ tagsView: RKTagsView, buttonForTagAt index: Int) -> UIButton  {
        let tagButton =  RKCustomButton(type: .system)
        tagButton.titleLabel?.font = tagList.font
        tagButton.setTitle(tagList.tags[index], for: .normal)
        tagButton.runBubbleAnimation()
        return tagButton
    }
}


// MARK: - Utility method
extension ItemDetailViewController {
    
    fileprivate func initializeAllfieldsData()
    {
//        print("ItemDetailViewController item id: \(item.id)")
//           print("ItemDetailViewController In item fileurl: \(item.images[0].fileURL)")
        self.itemNote.text = item.note
        self.itemTitle.text =  item.title
        if let date = item.scheduledDate {
            self.dueDateLabel.text = date
            self.dueDateLabel.isHidden = false
            self.dueDateImage.isHidden = false
        }
        
        if let date = item.alertDate {
            self.alertTimeLabel.text = date
            self.alertTimeLabel.isHidden = false
            self.alertImage.isHidden = false
        }
        
        
        for tag in item.tags {
            self.tagList.addTag(tag.tagName!)
        }
        
       
            for imageView in item.images {
                
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first
                {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageView.imageId)
                    let image    = UIImage(contentsOfFile: imageURL.path)
                    IGListData.append(IGListImageModel(image: image!))
                    adapter.performUpdates(animated: true, completion: nil)

                }
                
            }
        
        
        
    }
    
    fileprivate func alarmEmptyTextField(body: String){
        let view = MessageView.viewFromNib(layout: .StatusLine)
        
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(body: body)
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.duration = .seconds(seconds: 2)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = false
        SwiftMessages.show(config: config, view: view)
    
    }
    
    
        func updateTableViewAction() {
            let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
            NotificationCenter.default.post(updateContent as Notification)
        }
    
    
    fileprivate func confirmAddingItemToDB() {
        
     
        // set notification if alert date has been set 
        if let alertDate = self.alertDate {
            NotificationUtility.addLocalNotification(with: item.title, on: alertDate)
        }
        storeTags ()
        
        
        itemStore.add(item: item)
        
        self.navigationController?.popViewController(animated: true)
        
      //  FirebaseUtility.addPhotoToFirebase(from: item)
        FirebaseUtility.addItemToFirebase(with: item)
        updateTableViewAction()
    }
    
    // this should be called when leaving the page if this is a modification operation
    fileprivate func storeTags () {
    
        if tagList.tags.count != 0 {
            for tag in tagList.tags {
                let tagObj = Tag()
                tagObj.tagName = tag
                tagObj.itemId = item.id
                if isNewAddingItem == true {
                    item.tags.append(tagObj)
                }
                else {
                    try! db.write {
                        item.tags.append(tagObj)
                    }
                }

            }
        }
    }
    
    
}


extension ItemDetailViewController: MKDropdownMenuDelegate,MKDropdownMenuDataSource {
    
    
    
   
    // MARK: dropDownMenu

    fileprivate func setRowItems() {
        let dateButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
        dateTimeButton = dateButtonView.button
        dateTimeImage = dateButtonView.image
        let alertButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
        alertButton = alertButtonView.button
        alertImage = alertButtonView.image
        let addPhotoButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
        addPictureButton = addPhotoButtonView.button
        addPhotoImage = addPhotoButtonView.image
        let pinView = Bundle.main.loadNibNamed("PinSelectionMenuItem", owner: nil, options: nil)?.first as! PinSelectionMenuItem
        
  
        setAddPictureButton()
        setDatePicker()
        setAlertButton()
        
        rowItems.append(dateButtonView)
        rowItems.append(alertButtonView)
        rowItems.append(addPhotoButtonView)
        rowItems.append(pinView)
    }
    
    
    fileprivate func setDropDownMenu () {
        setRowItems()
        self.dropDownMenu = MKDropdownMenu(frame: CGRect(x: 0, y: 0, width: 150, height: 22))
        self.dropDownMenu.delegate = self
        dropDownMenu.dataSource = self
        dropDownMenu.backgroundDimmingOpacity = -0.67
        let indicator = UIImage(named: "indicator_toolMenu_itemDetail")
        dropDownMenu.disclosureIndicatorImage = indicator
        let spacer =  UIImageView.init(image: UIImage(named: "spacer_toolMenu_itemDetail"))
        dropDownMenu.spacerView = spacer
        spacer.contentMode = .center
        dropDownMenu.spacerViewOffset = UIOffsetMake(dropDownMenu.bounds.size.width/2 - (indicator?.size.width)!/2 - 8 , 1)
        self.dropDownMenu.dropdownShowsTopRowSeparator = false
        
        self.dropDownMenu.dropdownBouncesScroll = false
        
        self.dropDownMenu.rowSeparatorColor = UIColor(white: 1.0, alpha: 0.2)
        self.dropDownMenu.rowTextAlignment = .center;
        
        // Round all corners (by default only bottom corners are rounded)
        self.dropDownMenu.dropdownRoundedCorners = .allCorners;
        
        // Let the dropdown take the whole width of the screen with 10pt insets
        self.dropDownMenu.useFullScreenWidth = true;
        self.dropDownMenu.fullScreenInsetLeft = 10;
        self.dropDownMenu.fullScreenInsetRight = 10;
        
        // Add the dropdown menu to navigation bar
        self.navigationItem.titleView = self.dropDownMenu;
        
    }

    
    // MARK: datePicker

    fileprivate func setDatePicker () {
        
        
        let dateButtonImg = UIImage(named: "duedate_toolMenu_itemDetail")
        dateTimeButton.setTitle("Due date", for: .normal)
        dateTimeImage.image = dateButtonImg
        dateTimeImage.contentMode = .scaleAspectFit
        
        
        
        
        dateTimeButton.addTarget(self, action: #selector(self.tapDateTimeButton) , for: .touchUpInside)
        
        
    }
    
    
    func tapDateTimeButton () {
        weak var weakSelf = self
        self.datePicker.show("Pick A Due Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .dateAndTime) { (date) -> Void in
            
            if let userSelectedDate = date {
                
                let pickedDate  = DateUtility.stringFrom(date: userSelectedDate)
                weakSelf!.dateTimeButton.setTitle(pickedDate, for: .normal)
                weakSelf!.dueDateLabel.text = pickedDate
                weakSelf!.dueDateLabel.isHidden = false
                weakSelf!.dueDateImage.isHidden = false
                
                // db item
                if weakSelf!.isNewAddingItem == true {
                    
                    weakSelf!.item.scheduledDate = pickedDate
                    // state change
                    
                    let date = userSelectedDate
                    if date.isToday()  == true {
                        weakSelf!.item.state = "Today"
                    } else {
                        weakSelf!.item.state = "Scheduled"
                    }
                    
                    
                }
                else {
                    try! weakSelf!.db.write {
                        
                        weakSelf!.item.scheduledDate = pickedDate
                        // state change
                        
                        let date =  userSelectedDate
                        if date.isToday()  == true {
                            weakSelf!.item.state = "Today"
                        } else {
                            weakSelf!.item.state = "Scheduled"
                        }
                    }
                }
            }
            
            weakSelf!.dropDownMenu.closeAllComponents(animated: true)

        }
    }
    // MARK: alert
    
    fileprivate  func setAlertButton () {
        //alertButton.titleLabel?.textAlignment = .right
        
        alertButton.setTitle("Alert", for: .normal)
        alertImage.image = UIImage(named:"alertdate_toolMenu_itemDetail")
        alertImage.contentMode = .scaleAspectFit
    
        alertButton.addTarget(self, action: #selector(self.tapAlertButton) , for: .touchUpInside)
    }
    
    func tapAlertButton (){
        weak var weakSelf = self
        
        
        guard item.scheduledDate != nil else {
            // alert
            alarmEmptyTextField(body: "Please schedule a date first")
            return
            
        }
        self.alertView.show("Alert Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel") { _ in
            
            let selectedAlertOption = weakSelf!.alertView.alertChoiceTable.selectedAlertOption
            weakSelf!.alertButton.setTitle(selectedAlertOption, for: .normal)
            weakSelf!.alertTimeLabel.text = selectedAlertOption
            weakSelf!.alertTimeLabel.isHidden = false
            weakSelf!.alertTimeImage.isHidden = false
            let calculatedDateString = weakSelf!.calculateAlertDate(alertOption: selectedAlertOption)
            // db item
            if let calculatedDateString = calculatedDateString {
                print ("the alert date is:\(calculatedDateString)" )
                self.alertDate = DateUtility.dateFrom(dateString: calculatedDateString)!
                
                
                if weakSelf!.isNewAddingItem == true {
                    weakSelf!.item.alertDate = calculatedDateString
                }
                else {
                    try! weakSelf!.db.write {
                        weakSelf!.item.alertDate = calculatedDateString
                    }
                }
                
            }
            
            weakSelf!.dropDownMenu.closeAllComponents(animated: true)
        }
    }
    
    private func calculateAlertDate (alertOption : String?)  -> String?{
        
        guard let _alertOption = alertOption else {
            return nil
        }
        var date = DateUtility.dateFrom(dateString: item.scheduledDate!)!
        
        var alertDate : String?
        switch _alertOption {
        case "At time of event":
            break;
        case  "5 minutes before":
            date = (date - 5.minutes)!
        case  "15 minutes before":
            date = (date - 15.minutes)!
        case  "1 day before":
            date = (date - 1.day)!
        case  "1 hour before":
            date = (date - 1.hour)!
        default:
            break;
        }
        alertDate = DateUtility.stringFrom(date: date)
        return alertDate
    }

    
    // MARK: - addPhotoButton
    fileprivate func setAddPictureButton () {
        
        addPictureButton.setTitle("Picture", for: .normal)
        addPhotoImage.image = UIImage(named:"addPicture_itemDetail")
        addPhotoImage.contentMode = .scaleAspectFit
        self.addPictureButton.addTarget(self, action: #selector(self.tapAddPictureButton) , for: .touchUpInside)
        
    }
    
    
    func tapAddPictureButton () {
        triggerPictureAlubm()
    }
    
    // MARK: - location pin
    fileprivate func setLocatonPin() {
        
    }



    
    
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {

        return NSAttributedString.init(string: "Tools",
                                       attributes:  [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight), NSForegroundColorAttributeName: UIColor.flatBlack])
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForSelectedComponent component: Int) -> NSAttributedString? {
        return NSAttributedString.init(string: "Tools",
                                       attributes:  [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight), NSForegroundColorAttributeName: UIColor.flatBlack])

    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForRow row: Int, forComponent component: Int) -> UIColor? {
        return .clear
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return rowItems[row] as! UIView
    }
}

// unused
extension ItemDetailViewController {
    
    //    func initExpandableIcons()  {
    //         // let position = CGRect(x: 0, y: 450, width: self.view.frame.width, height: 70)
    //        let imageArray : [UIImage] = [
    //            UIImage(named: "inbox_menu")!,
    //            UIImage(named: "setting_menu")!,
    //            UIImage(named: "today_menu")!
    //        ]
    //        let expandable = AZExpandableIconListView(frame: position , images:imageArray)
    //        view.addSubview(expandable)
    //    }
    
}

//extension ItemDetailViewController : IGLDropDownMenuDelegate{
//    fileprivate func setDropDownMenu () {
//        var dropDownItems = Array<IGLDropDownItem>()
//        let dropDownItem1 = IGLDropDownItem()
//        dropDownItem1.iconImage = UIImage(named: "today_menu")
//        dropDownItem1.text = "set a due date"
//        dropDownItems.append(dropDownItem1)
//        let dropDownItem2 = IGLDropDownItem()
//        dropDownItem2.iconImage = UIImage(named: "scheduled_menu")
//        dropDownItem2.text = "alert"
//        dropDownItems.append(dropDownItem2)
//        let dropDownItem3 = IGLDropDownItem()
//        dropDownItem3.iconImage = UIImage(named: "Location_itemDetail")
//        dropDownItem3.text = "pin a location"
//        dropDownItems.append(dropDownItem3)
//        dropDownMenu = IGLDropDownMenu()
//        let width :CGFloat = 240.0
//        dropDownMenu.frame = CGRect(x: self.view.frame.width - width , y: (self.navigationController?.navigationBar.frame.size.height)!, width: width, height: 128)
//        dropDownMenu.paddingLeft = 15
//        dropDownMenu.type = .stack
//        dropDownMenu.itemAnimationDelay = 0.1
//        dropDownMenu.rotate = .random
//        dropDownMenu.dropDownItems = dropDownItems
//        dropDownMenu.delegate = self
//        self.view.addSubview(dropDownMenu)
//        dropDownMenu.reloadView()
//    }
//}

//
//  ItemDetail_MKDropdownDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import MKDropdownMenu

extension ItemDetailViewController: MKDropdownMenuDelegate {
    
    
    
    
    // MARK: dropDownMenu
    
    func setRowItems() {
        let dateButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
        dateTimeButton = dateButtonView.button
        dateTimeImage = dateButtonView.image
        let alertButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
        alertButton = alertButtonView.button
        alertImage = alertButtonView.image
//        let addPhotoButtonView = Bundle.main.loadNibNamed("CustomToolButtonView", owner: nil, options: nil)?.first as! CustomToolButtonView
//        addPictureButton = addPhotoButtonView.button
//        addPhotoImage = addPhotoButtonView.image
       // let pinView = Bundle.main.loadNibNamed("PinSelectionMenuItem", owner: nil, options: nil)?.first as! PinSelectionMenuItem
        
        
       //setAddPictureButton()
        setDatePicker()
        setAlertButton()
        
        rowItems.append(dateButtonView)
        rowItems.append(alertButtonView)
        //rowItems.append(addPhotoButtonView)
       // rowItems.append(pinView)
    }
    
    
    func setDropDownMenu () {
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
    
    func setDatePicker () {
        
        
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
                
                weakSelf!.resetAlertTime()
                
                
                let pickedDate  = DateUtilities.stringFrom(date: userSelectedDate)
                // dateTimeButton in the menu shall still appear as "Due date"
                //weakSelf!.dateTimeButton.setTitle(pickedDate, for: .normal)
                weakSelf!.dueDate_Label.text = pickedDate
                weakSelf!.dueDate_Label.isHidden = false
                weakSelf!.dueDate_ImageView.isHidden = false
                
                // db item
                
                
                weakSelf!.viewModel.item.scheduledDate = pickedDate
                // state change
                
                let date = userSelectedDate
                if date.compare(.isToday)  == true {
                    weakSelf!.viewModel.item.state = "Today"
                } else {
                    weakSelf!.viewModel.item.state = "Scheduled"
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
        
        
        guard viewModel.item.scheduledDate != nil else {
            // alert
            AlertMessage.alarmEmptyTextField(body: "Please schedule a date first")
            return
            
        }
        self.alertView.show("Alert Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel") { (tag) -> Void in
            
            // tag == 0 means user taps "Done" button, 1 means user tap “Cancel" button
            if tag == 0 {
                let selectedAlertOption = weakSelf!.alertView.alertChoiceTable.selectedAlertOption
                //weakSelf!.alertButton.setTitle(selectedAlertOption, for: .normal)
                weakSelf!.alertTime_Label.text = selectedAlertOption
                weakSelf!.alertTime_Label.isHidden = false
                weakSelf!.alertTime_ImageView.isHidden = false
                let calculatedDateString = weakSelf!.calculateAlertDate(alertOption: selectedAlertOption)
                // db item
                if let calculatedDateString = calculatedDateString {
                    Debug.log(message: "the alert date is:\(calculatedDateString)" )
                    self.alertDate = DateUtilities.dateFrom(dateString: calculatedDateString)!
                    
                    
                    
                    weakSelf!.viewModel.item.alertDate = calculatedDateString
                    
                    
                }
            }
            
            weakSelf!.dropDownMenu.closeAllComponents(animated: true)
        }
    }
    
    func resetAlertTime() {
        
        self.alertTime_Label.text = nil
        self.alertTime_Label.isHidden = true
        self.alertTime_ImageView.isHidden = true
        self.viewModel.item.alertDate = nil
        
    }
    
    func calculateAlertDate (alertOption : String?)  -> String?{
        
        guard let _alertOption = alertOption else {
            return nil
        }
        var date = DateUtilities.dateFrom(dateString: viewModel.item.scheduledDate!)!
        
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
        alertDate = DateUtilities.stringFrom(date: date)
        return alertDate
    }
    
    
    // MARK: - addPhotoButton
//    func setAddPictureButton () {
//        
//        
//        addPictureButton.setTitle("Picture", for: .normal)
//        addPhotoImage.image = UIImage(named:"addPicture_itemDetail")
//        addPhotoImage.contentMode = .scaleAspectFit
//        self.addPictureButton.addTarget(self, action: #selector(self.tapAddPictureButton) , for: .touchUpInside)
//        
//    }
//    
    
//    func tapAddPictureButton () {
//        triggerPictureAlubm()
//    }
//    
    // MARK: - location pin
    func setLocatonPin() {
        
    }
    
    
    
    
    
  
}

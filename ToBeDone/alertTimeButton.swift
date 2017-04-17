//
//  alertTimeButton.swift
//  ToBeDone
//
//  Created by 周星 on 4/17/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


class alertTimeButton : UIButton {
    
    var alertDate : Date?
    var alertImage : UIImageView!
    
    fileprivate  func setAlertButton () {
        //alertButton.titleLabel?.textAlignment = .right
        
        self.setTitle("Alert", for: .normal)
        alertImage.image = UIImage(named:"alertdate_toolMenu_itemDetail")
        alertImage.contentMode = .scaleAspectFit
        
        self.addTarget(self, action: #selector(self.tapAlertButton) , for: .touchUpInside)
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

}

//
//  dateTimeButton.swift
//  ToBeDone
//
//  Created by 周星 on 4/17/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


class dateTimeButton : UIButton {
    
    private var dateTimeImage : UIImageView!
    private var datePicker = DatePickerDialog()
    
    
    typealias tapButtonHandler =  (date) -> Void
    var handler : tapButtonHandler?

    
    init(frame: CGRect, title: String?, image:UIImage?) {
        super.init(frame: frame)
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
    private func setDatePicker () {
        
        
        let dateButtonImg = UIImage(named: "duedate_toolMenu_itemDetail")
        self.setTitle("Due date", for: .normal)
        self.setImage(dateButtonImg, for: .normal)
        self.contentMode = .scaleAspectFit
    
        self.(self, action: #selector(self.tapDateTimeButton) , for: .touchUpInside)
        
        
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
                
                weakSelf?.itemState.itemScheduledDate = pickedDate
                
                
                if userSelectedDate.isToday() == true {
                    weakSelf!.itemState.itemState = "Today"
                } else {
                    weakSelf!.itemState.itemState = "Scheduled"
                }
                
                
                
            }
            
            weakSelf!.dropDownMenu.closeAllComponents(animated: true)
            
        }
    }
    
    
}

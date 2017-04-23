//
//  ItemDetail_TextDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


extension ItemDetailViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.itemTitle_TextField {
            if self.itemTitle_TextField.text == "" {
                AlertMessage.alarmEmptyTextField(body: "title shouldn't be empty")
            }
            
            self.viewModel.item.title = textField.text!
            
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


//
//  ItemDetail_TextViewDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

extension ItemDetailViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.itemNote_TextView.resignFirstResponder()
        
        self.viewModel.item.note = textView.text
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textViewDidEndEditing(textView)
            return false
        }
        
        return true
        
    }
}

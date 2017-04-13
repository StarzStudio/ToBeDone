//
//  WriteReviewViewController.swift
//  ToBeDone
//
//  Created by 周星 on 12/6/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import FlatUIKit
class WriteReviewViewController: UIViewController {

    
    @IBOutlet weak var textViewView : UITextView!
    @IBOutlet weak var button : FUIButton!
    override func viewDidLoad() {
        textViewView.delegate = self
        
        textViewView.layer.borderWidth = 4
        textViewView.layer.cornerRadius = 4
        super.viewDidLoad()
        button.setTitle("Send", for: .normal)
        self.button.buttonColor = UIColor.turquoise()
        self.button.shadowColor = UIColor.greenSea()
        self.button.shadowHeight = 3.0
        self.button.cornerRadius = 6.0
        self.button.titleLabel?.font = UIFont.boldFlatFont(ofSize: 16)
        button .setTitleColor(UIColor.clouds(), for: .highlighted)
        self.button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapButton(_ sender: FUIButton) {
        textViewView.text = ""
        textViewDidEndEditing(self.textViewView)
    }
}

extension WriteReviewViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.textViewView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textViewDidEndEditing(textView)
            return false
        }
        
        return true
        
        
    }
}

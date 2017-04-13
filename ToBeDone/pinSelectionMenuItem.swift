//
//  pinSelectionMenuItem.swift
//  ToBeDone
//
//  Created by 周星 on 12/2/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import FlatUIKit


class PinSelectionMenuItem: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
            let pinSwitchOn = NSNotification.Name(rawValue:"pinSwitchOn")
            let pinSwitchOff = NSNotification.Name(rawValue:"pinSwitchOff")
    
     @IBOutlet weak var image:UIImageView!
      @IBOutlet weak var label:UILabel!
      @IBOutlet weak var switchControl : FUISwitch!
    override func awakeFromNib() {
            setSwitchControl()
    }
    
    
    
   
    //通知处理函数
    func didMsgRecv(notification:NSNotification){
        print("didMsgRecv: \(notification.userInfo)")
    }
    
    
    fileprivate func setSwitchControl () {
        self.switchControl.onColor = UIColor.flatWhite
        self.switchControl.offColor = UIColor.clouds()
        self.switchControl.onBackgroundColor = UIColor.flatGreen
        self.switchControl.offBackgroundColor = UIColor.silver()
        self.switchControl.offLabel.font = UIFont.boldFlatFont(ofSize: 14)
        self.switchControl.onLabel.font = UIFont.boldFlatFont(ofSize: 14)
        self.switchControl.setOn(true, animated:true)
    
    }

    @IBAction func switchActon(_ sender: Any) {
        if switchControl.isOn == true {
            let on = NSNotification(name: pinSwitchOn, object: self)
            NotificationCenter.default.post(on as Notification)
        }
        else {
            let off = NSNotification(name: pinSwitchOff, object: self)
            NotificationCenter.default.post(off as Notification)

        }
    }
}

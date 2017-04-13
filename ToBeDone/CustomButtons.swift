//
//  CustomButtons.swift
//  ToBeDone
//
//  Created by 周星 on 11/9/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import UIKit


class imgLeftTitleRightButton: customButton {
    
    override init(frame: CGRect, title: String?, image:UIImage?) {
        super.init(frame: frame, title:title,image:image)
           titleRatioInButton = 0.95
    }
    
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleRatioInButton = 0.95
    }
    
    
}

class alertButton: customButton {
    
    
    
    override init(frame: CGRect, title: String?, image:UIImage?) {
        super.init(frame: frame, title:title,image:image)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
}


class customButton: UIButton {
    
    typealias tapButtonHandler = () -> ()
    var handler : tapButtonHandler?
    var titleRatioInButton = 0.9
    var fontSize : CGFloat = 15.0
    var buttonTitle : String?
    var buttonImg : UIImage?
    
    init(frame: CGRect, title: String?, image:UIImage?) {
        super.init(frame: frame)
        self.setTitle(newTitle: title)
        self.setImg(newImg:image)
        self.setTitle(self.buttonTitle, for: UIControlState.normal)
        self.setImage(self.buttonImg, for: UIControlState.normal)
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.font  = UIFont.systemFont(ofSize: fontSize)
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.imageView?.contentMode = UIViewContentMode.scaleToFill
        // self.handler = handler
        // self.addTarget(self, action: #selector(self.tapButton) , for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.font  = UIFont.systemFont(ofSize: fontSize)
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.imageView?.contentMode = UIViewContentMode.scaleToFill
    }
    
    func setImg(newImg: UIImage?){
        if let _Img = newImg {
            buttonImg = _Img
            self.setImage(buttonImg, for: UIControlState.normal)
        }
    }
    
    func setTitle(newTitle:String?) {
        if let _title = newTitle {
            buttonTitle = _title
            self.setTitle(buttonTitle, for: UIControlState.normal)
        }
    }
    
    
    // layout for title and image
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let imageX : CGFloat = 0.0
        let imageY : CGFloat = 0.0
        let imageWidth : CGFloat = contentRect.size.width * CGFloat(1 - titleRatioInButton)
        let imageHeight : CGFloat = contentRect.size.height
        return CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let titleX : CGFloat =  contentRect.size.width * CGFloat(1 - titleRatioInButton)
        let titleY : CGFloat = 0
        let titleXWidth = contentRect.size.width * CGFloat(titleRatioInButton)
        let titleXHeight : CGFloat = contentRect.size.height
        return CGRect(x: titleX,y: titleY,width: titleXWidth,height: titleXHeight)
        
        
    }
}


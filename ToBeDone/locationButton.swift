//
//  locationButton.swift
//  ToBeDone
//
//  Created by 周星 on 4/17/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

class locationButton : UIButton {

    func setLocationButton () {
        
        let placeName = ""
        let locationButtonImg = UIImage(named: "Location_ItemDetail")
        locationButton.setTitle(newTitle: placeName)
        locationButton.setImg(newImg: locationButtonImg)
        locationButton.addTarget(self, action: #selector(self.tapLocationButton) , for: .touchUpInside)
        
        // getLocation()
    }
    
    fileprivate getLocation() {
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

}

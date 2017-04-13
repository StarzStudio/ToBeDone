//
//  LocationRow_TableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 11/8/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit
import Eureka
import MapKit

public class LocationCell: Cell<LocationModel>, CellType  {
    
     var button : UIButton!
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    public override func setup() {
        super.setup()
        
        guard let locationModel = row.value else { return }
        
        let tapButton = {() -> () in  print("button taped.")}
        
        if let placeName = locationModel.placeName {
            
            button = imgLeftTitleRightButton(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height),
                                       title: placeName,
                                       image: UIImage(named: "Location_ItemDetail") )
            
            self.addSubview(button)
        
        }
        
        
    }
    
    
    public override func update() {
        super.update()
        
    }
}




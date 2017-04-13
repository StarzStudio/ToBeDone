//
//  ProfileCell.swift
//  ToBeDone
//
//  Created by Xinghe Lu on 12/6/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    let defaultUserProfileImage = UIImage(named: "Default_Profile_Image")! as UIImage
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.image = defaultUserProfileImage
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //profileImage = UIImage(named: )
        // Configure the view for the selected state
    }

}

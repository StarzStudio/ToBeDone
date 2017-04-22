//
//  AlertMessage.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import SwiftMessages
class AlertMessage {
    class func alarmEmptyTextField(body: String){
        let view = MessageView.viewFromNib(layout: .StatusLine)
        
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(body: body)
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.duration = .seconds(seconds: 2)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = false
        SwiftMessages.show(config: config, view: view)
    }

}

//
//  MainView+FlowingMenuDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import FlowingMenu

extension MainViewController : FlowingMenuDelegate {
    // MARK: - FlowingMenu Delegate Methods
    
    func colorOfElasticShapeInFlowingMenu(_ flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        return mainColor
    }
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName, sender: self)
        showDemoControllerForIndex(self.selectedIndex)
        print ("flowingMenuNeedsDismissMenu: selected Index: \(selectedIndex)")
    }
    
}

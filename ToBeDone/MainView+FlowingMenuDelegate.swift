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
//        return UIColor(hex: 0xC4ABAA)
        return UIColor(red: 0.99, green: 0.73, blue: 0.17, alpha: 1)
    }
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName, sender: self)
        self.showItemTableForIndex(self.selectedIndex)
        print ("flowingMenuNeedsDismissMenu: selected Index: \(selectedIndex)")
    }
    
}

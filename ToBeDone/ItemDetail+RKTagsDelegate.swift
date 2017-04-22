//
//  ItemDetail_RKTagsDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import RKTagsView

extension ItemDetailViewController: RKTagsViewDelegate {
    func tagsView(_ tagsView: RKTagsView, buttonForTagAt index: Int) -> UIButton  {
        let tagButton =  RKCustomButton(type: .system)
        tagButton.titleLabel?.font = self.tagList_TagsView.font
        tagButton.setTitle( self.tagList_TagsView.tags[index], for: .normal)
        tagButton.runBubbleAnimation()
        return tagButton
    }
}

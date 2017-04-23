//
//  depravated.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


extension ItemDetailViewController {
    
    //    func setAddTagButton() {
    //
    //        addTagButton.setImage(UIImage(named: "addTag_itemDetail"), for: UIControlState.normal)
    //        addTagButton.imageView?.contentMode = .scaleAspectFit
    //
    //        addTagButton.addTarget(self, action: #selector(self.tapAddTagButton) , for: .touchUpInside)
    //
    //    }
    
    //    func setConstraint(){
    //        let superview = self.view.superview!
    //        let addTagButton = self.addTagButton!
    //        let newTagContent = self.newTagContent!
    //        let tagList = self.tagList!
    //        let itemNote = self.itemNote!
    //        let subTasksTable = self.subTasksTable!
    //        let dateTimeButton = self.dateTimeButton!
    //        let alertButton = self.alertButton!
    //        let locationButton = self.locationButton!
    //
    //        addTagButton.snp.makeConstraints { make in
    //           make.top.equalTo(superview.snp.top).offset(20)
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(newTagContent.snp.left).offset(-8)
    //            make.bottom.equalTo(tagList.snp.top).offset(-8)
    //            make.size.equalTo(CGSize(width: 20, height: 20))
    //        }
    //
    //        newTagContent.snp.makeConstraints { make in
    //            make.top.equalTo(superview.snp.top).offset(20)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //            make.bottom.equalTo(tagList.snp.top).offset(-8)
    //            make.height.equalTo(20)
    //        }
    //
    //        tagList.snp.makeConstraints {make in
    //            make.top.equalTo(addTagButton.snp.bottom).offset(8)
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //           make.bottom.equalTo(itemNote.snp.top).offset(-8)
    //            make.height.equalTo(30)
    //        }
    
    //        itemNote.snp.makeConstraints { make in
    //            make.top.equalTo(tagList.snp.bottom).offset(8)
    //
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //                make.bottom.equalTo(subTasksTable.snp.top).offset(-8)
    //             make.height.equalTo(40)
    //
    //        }
    //
    //        subTasksTable.snp.makeConstraints { make in
    //             make.top.equalTo(itemNote.snp.bottom).offset(8)
    //
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //            make.bottom.equalTo(dateTimeButton.snp.top).offset(-8)
    //            make.height.equalTo(20)
    //        }
    //
    //        dateTimeButton.snp.makeConstraints { make in
    //            make.top.equalTo(subTasksTable.snp.bottom).offset(8)
    //
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //                make.bottom.equalTo(alertButton.snp.top).offset(-8)
    //            make.height.equalTo(20)
    //        }
    //
    //        alertButton.snp.makeConstraints {make in
    //            make.top.equalTo(dateTimeButton.snp.bottom).offset(8)
    //
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //                make.bottom.equalTo(locationButton.snp.top).offset(-8)
    //            make.height.equalTo(40)
    //        }
    //
    //        locationButton.snp.makeConstraints { make in
    //            make.top.equalTo(alertButton.snp.bottom).offset(8)
    //
    //            make.left.equalTo(superview.snp.left).offset(8)
    //            make.right.equalTo(superview.snp.right).offset(-8)
    //            make.bottom.equalTo(superview.snp.top).offset(80)
    //            make.height.equalTo(40)
    //        }
    //        
    
    //}
    
    
    
//    var IGListData : [IGListImageModel]! = [IGListImageModel(image:UIImage())]
//    lazy var adapter: IGListAdapter = {
//        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
//    }()
//    // MARK: IGList image set
//    
//    
//    
//    fileprivate func setIGListCollectionView () {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 10
//        //    layout.sectionInset = UIEdgeInsetsMake(3, 5, 3, 5)
//        self.IGListImageSet_CollectionView.alwaysBounceVertical = false
//        self.IGListImageSet_CollectionView.alwaysBounceHorizontal = true
//        self.IGListImageSet_CollectionView.collectionViewLayout = layout
//        self.IGListImageSet_CollectionView.allowsSelection = true
//        adapter.collectionView = self.IGListImageSet_CollectionView
//        adapter.dataSource = self
//        
//    }
//    
//    
//    
//    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
//        // this can be anything!
//        return IGListData!
//        
//    }
//    
//    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
//        
//        return IGListImageSectionController()
//    }
//    
//    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
//        return nil
//    }
//    
//    
//    fileprivate func setIGListDataForTest () {
//        let image1 = UIImage(named: "shoppingList1_Test")!
//        let image2 = UIImage(named: "shoppingList2_Test")!
//        let image3 = UIImage(named: "memo_Test")!
//        IGListData.append(IGListImageModel(image: image1))
//        IGListData.append(IGListImageModel(image: image2))
//        IGListData.append(IGListImageModel(image: image3))
//        adapter.performUpdates(animated: true, completion: nil)
//    }
//    
//    func updateIGListDataSource (image:UIImage) {
//        let IGListimageModel = IGListImageModel(image: image)
//        IGListData.append(IGListimageModel)
//        adapter.performUpdates(animated: true, completion: nil)
//        
//        // update db
//        self.viewModel.item.images[UUID().uuidString] = image
//        
//        
//    }
}

//extension ItemDetailViewController : IGLDropDownMenuDelegate{
//    fileprivate func setDropDownMenu () {
//        var dropDownItems = Array<IGLDropDownItem>()
//        let dropDownItem1 = IGLDropDownItem()
//        dropDownItem1.iconImage = UIImage(named: "today_menu")
//        dropDownItem1.text = "set a due date"
//        dropDownItems.append(dropDownItem1)
//        let dropDownItem2 = IGLDropDownItem()
//        dropDownItem2.iconImage = UIImage(named: "scheduled_menu")
//        dropDownItem2.text = "alert"
//        dropDownItems.append(dropDownItem2)
//        let dropDownItem3 = IGLDropDownItem()
//        dropDownItem3.iconImage = UIImage(named: "Location_itemDetail")
//        dropDownItem3.text = "pin a location"
//        dropDownItems.append(dropDownItem3)
//        dropDownMenu = IGLDropDownMenu()
//        let width :CGFloat = 240.0
//        dropDownMenu.frame = CGRect(x: self.view.frame.width - width , y: (self.navigationController?.navigationBar.frame.size.height)!, width: width, height: 128)
//        dropDownMenu.paddingLeft = 15
//        dropDownMenu.type = .stack
//        dropDownMenu.itemAnimationDelay = 0.1
//        dropDownMenu.rotate = .random
//        dropDownMenu.dropDownItems = dropDownItems
//        dropDownMenu.delegate = self
//        self.view.addSubview(dropDownMenu)
//        dropDownMenu.reloadView()
//    }
//}




//extension ItemDetailViewController: TagListViewDelegate {

//    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        alertToDeleteTag(tagName: title)
//    }
//
//    fileprivate func alertToDeleteTag (tagName: String) {
//        let alertController = UIAlertController(title: "Delete tag",
//                                                message: "Are you sure to delete this tag?", preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title: "No",
//                                         style: UIAlertActionStyle.cancel,
//                                         handler: nil)
//
//        let confirmAction = UIAlertAction(title:"Yes", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
//            self.tagList.removeTag(tagName)
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(confirmAction)
//        self.present(alertController, animated: true, completion: nil)
//
//    }

//}

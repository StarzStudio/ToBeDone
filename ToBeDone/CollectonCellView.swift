//
//  CollectionCellView.swift
//  ToBeDone
//
//  Created by 周星 on 11/27/16.
//  Copyright © 2016 周星. All rights reserved.
//
//  To use : first call getViewContent to fill data into this class,
//  then, call setViewContent to let the view show the data
//
//  public interface :
//  setViewContent([String], [image], String)
/*
 function operation: set the content of the cell view
 - parameter 1: tag array
 - parameter 2: image array
 - parameter 3: title (or so-called note)
 */

import UIKit
import IGListKit
import RKTagsView


class CollectionCellViewController: UIViewController ,IGListAdapterDataSource {
    
    var item: TodoItem!
    
    
    
    var IGListData : [IGListImageModel]! = [IGListImageModel(image:UIImage())]
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
  
    var images: [UIImage]?
    
    
    var imageSet: IGListCollectionView!
     override func viewDidLoad() {
        
        print("33333333 viewDidLoad")
        setIGListCollectionView()
       
        
        getViewContent()
        setViewContent()

        //setViewContent()
    }
    
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        // this can be anything!
        return IGListData!
        
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        
        return previewIGListImageSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
    
    fileprivate func setIGListCollectionView () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        //    layout.sectionInset = UIEdgeInsetsMake(3, 5, 3, 5)
        imageSet.alwaysBounceVertical = false
        imageSet.alwaysBounceHorizontal = true
        imageSet.collectionViewLayout = layout
        imageSet.allowsSelection = true
        adapter.collectionView = imageSet
        adapter.dataSource = self
        
    }
    
    
    
    public func getViewContent()  {
        for image in item.images {
            let imageToShown = UIImage(contentsOfFile: image.fileURL!)
            self.images?.append(imageToShown!)
        }
        
    }
    
    public func setViewContent() {
        
        if let images = self.images {
            for image in images {
                addImage(image: image)
            }
        }
        

    }
    

    public func addImage (image:UIImage) {
        let IGListimageModel = IGListImageModel(image: image)
        IGListData.append(IGListimageModel)
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    
    
    
}

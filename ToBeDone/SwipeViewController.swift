////
////  SwipeViewController.swift
////  ToBeDone
////
////  Created by 周星 on 12/5/16.
////  Copyright © 2016 周星. All rights reserved.
////
//
//import UIKit
//import IGListKit
//class SwipeViewController: UIViewController {
//
//    var IGListData : [TodoItem]! = [TodoItem()]
//    lazy var adapter: IGListAdapter = {
//        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
//    }()
//    
//
//    @IBOutlet weak var iglistView: IGListCollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
//        // this can be anything!
//        return IGListData! as!
//        
//    }
//    
//    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
//        
//        return SwipeIGListController()
//    }
//    
//    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
//        return nil
//    }
//
//    
//    fileprivate func setIGListCollectionView () {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 10
//        //    layout.sectionInset = UIEdgeInsetsMake(3, 5, 3, 5)
//        iglistView.alwaysBounceVertical = false
//        iglistView.alwaysBounceHorizontal = true
//        iglistView.collectionViewLayout = layout
//        iglistView.allowsSelection = true
//        adapter.collectionView = iglistView
//        adapter.dataSource = self
//        
//    }
//
//    
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

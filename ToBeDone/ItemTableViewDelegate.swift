//
//  ItemTableViewDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


extension ItemTableViewController {


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // jump to existing detail view
        tableView.deselectRow(at: indexPath, animated: true)
        let itemDetailVC = UIStoryboard(name: "ItemDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        //print("before pushViewController")
        self.parent?.navigationController?.pushViewController(itemDetailVC, animated: true)
        //print("after pushViewController")

        itemDetailVC.viewModel.modifyItem(itemToBeModified: self.viewModel.itemsCollection[indexPath.row])
        //            print("tableView In item id: \(item.id)")
        //             print("tableView In item fileurl: \(item.images[0].fileURL)")
        setNavigationControllerForItemDetail(detailView: itemDetailVC)
    }


}

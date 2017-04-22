//
//  ItemTableViewDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation


extension ItemTableViewController  {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // jump to existing detail view
        
        
        
        
        switch collectionType! {
            
        case "Trash":
            // the cell will shown as grey color to indicate this can not be clicked
            break
        case "LogBook" :
            fallthrough
        default:
            
            if collectionType! == "Scheduled" {
                item = sections[indexPath.section][indexPath.row]
            }
            else {
                item = items[indexPath.row]
            }
            
            
            let itemDetailVC = UIStoryboard(name: "ItemDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController" ) as! ItemDetailViewController
            //print("before pushViewController")
            self.parent?.navigationController?.pushViewController(itemDetailVC, animated: true)
            //print("after pushViewController")
            var urls = Array<String>()
            if item.images.count > 0 {
                for  image in item.images {
                    urls.append(image.fileURL!)
                }
            }
            if urls.count > 0 {
                itemDetailVC.imageURLs = urls
            }
            itemDetailVC.viewModel.modifyItem(itemToBeModified: item)
            //            print("tableView In item id: \(item.id)")
            //             print("tableView In item fileurl: \(item.images[0].fileURL)")
            setNavigationControllerForItemDetail(detailView: itemDetailVC)
        }
        
        
    }

}

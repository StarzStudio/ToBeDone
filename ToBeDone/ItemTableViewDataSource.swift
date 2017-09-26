//
//  ItemTableViewDataSource.swift
//  ToBeDone
//
//  Created by 周星 on 4/21/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation

extension ItemTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {//number of section
        if viewModel.currentTableContentType == "Scheduled" {
            return self.viewModel.scheduledSections.count
        }
        else {
            return 1

        }
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of item in each section
        
        if viewModel.currentTableContentType == "Scheduled" {
            return self.viewModel.scheduledSections[section].itemCells.count
        }
        else {
            return viewModel.itemCellModelsCollection.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//load data into each row

        var itemCellModel : ItemCellModel!
        if viewModel.currentTableContentType == "Scheduled" {
            itemCellModel = self.viewModel.scheduledSections[indexPath.section].itemCells[indexPath.row]
        }
        else {
            itemCellModel = self.viewModel.itemCellModelsCollection[indexPath.row]
        }
        
        
        switch itemCellModel.cellType {
        case .ArchivedCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArchivedItemTableCell",
                    for: indexPath) as! ArchivedItemTableCell
            cell.cellModel = itemCellModel
            return cell
        case .NormalCellWithImages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell_WithImage",
                    for: indexPath) as! ItemTableCell_WithImage
            cell.cellModel = itemCellModel
            return cell
        case .NormailCellWithoutImages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell_WithoutImage",
                    for: indexPath) as! ItemTableCell_WithoutImage
            cell.cellModel = itemCellModel
            return cell
            
        }

    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if viewModel.currentTableContentType == "Scheduled" {
            return self.viewModel.scheduledSections[section].title!
        }
        else {
            return ""
        }

    }
    
   
    


}

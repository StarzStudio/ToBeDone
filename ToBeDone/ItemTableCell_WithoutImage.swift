//
//  newTableCellWithNoPhotoTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 12/6/16.
//  Copyright © 2016 周星. All rights reserved.
//

import UIKit

class ItemTableCell_WithoutImage: UITableViewCell {
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    

    var viewModel = ItemTableViewModel.sharedInstance
    var checkedImage  : UIImage?
    var uncheckedImage : UIImage?
    var cellModel : ItemCellModel? {

        didSet  {
            titleLabel.text = cellModel!.title
            noteLabel.text = cellModel!.note
            checkedImage = UIImage(named: cellModel!.checkedImageName)! as UIImage
            uncheckedImage = UIImage(named: cellModel!.unCheckedImageName)! as UIImage
        }
    }
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                
                guard nil != checkedImage else {
                    Debug.log(message: "checkedImage doesn't set")
                    return
                }
                selectButton.setImage(checkedImage, for: .normal)
                
                viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .Select)
            } else {
                
                guard nil != uncheckedImage else {
                    Debug.log(message: "unCheckedImage doesn't set")
                    return
                }
                selectButton.setImage(uncheckedImage, for: .normal)
                
                viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .DisSelect)
            }
        }
    }
    

    @IBAction func tapSelectButton(_ sender: Any) {
        
        Debug.log(message: "select button tap")
        isChecked = !isChecked
        
    }
    
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .Delete)
        viewModel.updateTableViewAction()
    }
    
    @IBAction func tapLogButton(_ sender: Any) {
        
        viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .Log)
        viewModel.updateTableViewAction()
    }
    
    
    
    // do all the pre setting
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initTitle()
        initNote()
       
        
        
        //setViewContent()
        
        
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

    func initTitle () {
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.textColor = UIColor.flatGray
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        // automatica number of lines
        titleLabel.numberOfLines = 0

    }
    
    func initNote () {
        noteLabel.textAlignment = NSTextAlignment.left
        noteLabel.textColor = UIColor.flatGray
        noteLabel.backgroundColor = UIColor.clear
        noteLabel.font = UIFont.boldSystemFont(ofSize: 15)
        // automatica number of lines
        noteLabel.numberOfLines = 0

    }
    

   

    
}

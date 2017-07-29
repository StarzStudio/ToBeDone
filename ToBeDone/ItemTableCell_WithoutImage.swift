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

    @IBOutlet weak var shadowView : UIView!
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
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
    
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete a stick", message: "Are you sure to delete this stick?", preferredStyle: UIAlertControllerStyle.alert)
        
        weak var weakSelf = self
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            weakSelf!.viewModel.actionOnSingleCell(itemCellIndex: weakSelf!.cellModel!.cellIndex!, actionType: .Delete)
            weakSelf!.viewModel.updateTableViewAction()

            print("Delete button tapped")
        })
        alertController.addAction(deleteAction)
        
        let okAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            
            print("OK button tapped")
        })
        alertController.addAction(okAction)
        
        self.parentViewController?.present(alertController, animated: true, completion: nil)
        
        
           }



    
    @IBAction func tapLogButton(_ sender: Any) {
        
        viewModel.actionOnSingleCell(itemCellIndex: cellModel!.cellIndex!, actionType: .Log)
        viewModel.updateTableViewAction()
    }
    
    
    
    // do all the pre setting
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clear
        initShadowView();
        initTitle()
        initNote()
       
        
        
        //setViewContent()
        
        
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initShadowView() {
        shadowView.layer.shadowColor =  UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }

    func initTitle () {
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.backgroundColor = UIColor.clear
        // automatica number of lines
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        let maxLabelSize = CGSize(width: titleLabel.frame.size.width, height: 50)
        titleLabel.frame.size = titleLabel.text!.boundingRect(with: maxLabelSize,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName : titleLabel.font],
                context: nil).size

    }
    
    func initNote () {
        noteLabel.textAlignment = NSTextAlignment.left
        noteLabel.backgroundColor = UIColor.clear
        // automatica number of lines
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        let maxLabelSize = CGSize(width: noteLabel.frame.size.width, height: 50)
        noteLabel.frame.size = noteLabel.text!.boundingRect(with: maxLabelSize,
                                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                              attributes: [NSFontAttributeName : noteLabel.font],
                                                              context: nil).size
        
        self.contentView.layoutIfNeeded()
        self.contentView.sizeToFit()
    }
    

   

    
}

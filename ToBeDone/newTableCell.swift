//
//  newTableCellTableViewCell.swift
//  ToBeDone
//
//  Created by 周星 on 12/4/16.
//  Copyright © 2016 周星. All rights reserved.
//
//
import UIKit
import IGListKit


class newTableCell: UITableViewCell {
    var db = TodoItemStore.sharedInstance.getDB()!
    var item: TodoItem!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    var imageViewArray = Array<UIImageView>()
    
    var itemTitleText : String?
    var images: [UIImage]?
    
    var collectionCellViewController : CollectionCellViewController!
    @IBOutlet weak var imageListView:  IGListCollectionView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var checkedImage = UIImage(named: "ic_CheckedCheckBox")! as UIImage
    var uncheckedImage = UIImage(named: "ic_UncheckedCheckBox")! as UIImage
    
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                selectButton.setImage(checkedImage, for: .normal)
            } else {
                selectButton.setImage(uncheckedImage, for: .normal)

            }
        }
    }
    
    
    
    
    let updateTableViewNotifiName = NSNotification.Name(rawValue:"updateTableView")
    
    

    @IBAction func tapSelectButton(_ sender: Any) {
        
        isChecked = !isChecked
        try! db.write {
            item.checked = isChecked
        }
        print("select button tap")
    }
    
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        try! db.write {
            item.state = "Trash"
        }
        
        print("delete button tap")
        // call the dataSource in the tableview
        // set notification
        updateTableViewAction()
    }
    
    @IBAction func tapLogButton(_ sender: Any) {
        try! db.write {
            item.state = "LogBook"
        }
        
        print("log button tap")
        updateTableViewAction()
    }
    
    func updateTableViewAction() {
        let updateContent = NSNotification(name: updateTableViewNotifiName, object: self)
        NotificationCenter.default.post(updateContent as Notification)
    }
  

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        print("11111111111awakeFromNib")
        // add data to the collectonCellViewController
        
        
        initItemTitle()
        if let image1 = image1 {
         imageViewArray.append(image1)
        }
        if let image2 = image2 {
            imageViewArray.append(image2)
        }
        if let image3 = image3 {
            imageViewArray.append(image3)
        }
       
        
        
        
        //setViewContent()

        
    }

    
    func fillDataIntoCollectionCellViewController(_ item: TodoItem) {
        
        self.item = item
        print("222222222fillDataIntoCollectionCellViewController")
//        self.getViewContent()
//        self.setViewContent()
        self.itemTitle.text = item.title
        var i = 0
        for imageView in item.images {
            
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageView.imageId)
                let image    = UIImage(contentsOfFile: imageURL.path)
                imageViewArray[i].image = image
            }
            
        }
        
//        collectionCellViewController = CollectionCellViewController()
//         collectionCellViewController.item = item
//        collectionCellViewController.getViewContent()
//        collectionCellViewController.setViewContent()
//        imageListView = collectionCellViewController.imageSet

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func initItemTitle () {
        
        itemTitle.textAlignment = NSTextAlignment.left
        itemTitle.textColor = UIColor.flatGray
        itemTitle.backgroundColor = UIColor.clear
        itemTitle.font = UIFont.boldSystemFont(ofSize: 15)
        
    }
    
    
    public func getViewContent()  {
       
        self.itemTitleText = item.title
    }
    
    public func setViewContent() {
        
    //   image1.image = item.
        setItemTitle(title: self.itemTitleText!)
        
    }
    
    public func setItemTitle (title: String) {
        if let itemTitle = self.itemTitle {
            itemTitle.text = title
        }
        
    }
    

    
}

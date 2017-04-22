//
//  ItemDetailViewControllerImagePickerDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos
import PhotosUI
import AssetsLibrary

extension ItemDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func triggerPictureAlubm (){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        self.dropDownMenu.closeAllComponents(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = info["UIImagePickerControllerMediaType"] as! String
        if type  == (kUTTypeImage as String)  {
            let fetchedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            updateIGListDataSource(image: fetchedImage)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateIGListDataSource (image:UIImage) {
        let IGListimageModel = IGListImageModel(image: image)
        IGListData.append(IGListimageModel)
        adapter.performUpdates(animated: true, completion: nil)
        
        // update db
        self.viewModel.addImage(image)
        
        
    }
    
//    func storeImageToFile(image: UIImage, imageName: String) -> String?{
//        if let data = UIImagePNGRepresentation(image) {
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let imageName = imageName
//            let destinationPath = documentsURL.appendingPathComponent(imageName)
//            try? data.write(to: destinationPath)
//            return destinationPath.absoluteString
//        }
//        else { return nil }
//        
//    }
    
    //    fileprivate func storeImageToDB(image: UIImage) {
    //
    //        let dbImageModel = ImageFile()
    //        let imageName = dbImageModel.imageId
    //        dbImageModel.fileURL = storeImageToFile(image: image, imageName: imageName)
    //        dbImageModel.itemId = item.id
    //        if isNewAddingItem == true {
    //            item.images.append(dbImageModel)
    //        }
    //        else {
    //            try! db.write {
    //                item.images.append(dbImageModel)
    //            }
    //        }
    //
    //
    //    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.itemTitle_TextField.isFirstResponder  == true {
            self.itemTitle_TextField.resignFirstResponder()
        }
        if self.itemNote_TextView.isFirstResponder == true {
            self.itemNote_TextView.resignFirstResponder()
        }
    }
    
    
}

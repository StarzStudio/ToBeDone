//
//  ItemDetailViewControllerImagePickerDelegate.swift
//  ToBeDone
//
//  Created by 周星 on 4/19/17.
//  Copyright © 2017 周星. All rights reserved.
//

//import Foundation
//import MobileCoreServices
//import Photos
//import PhotosUI
//import AssetsLibrary

//extension ItemDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    internal func triggerPictureAlubm (){
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true, completion: nil)
//        self.dropDownMenu.closeAllComponents(animated: true)
//        
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let type = info["UIImagePickerControllerMediaType"] as! String
//        if type  == (kUTTypeImage as String)  {
//            let fetchedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            updateCollectionView(image: fetchedImage)
//            
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func
//    
//}

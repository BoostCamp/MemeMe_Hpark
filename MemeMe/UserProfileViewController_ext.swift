//
//  UserProfileViewController_ext.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

extension UserProfileViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let currentUserRef = DataService.instance.REF_USER_CURRENT, let text = textField.text {
            currentUserRef.updateChildValues(["username": text])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // present image picker
    func presentImagePickerController(_ source: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // after finished picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImage.image = image
            userImage.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  MemeEditorViewController_ext.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // present image picker
    func presentImagePickerController(_ source: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // after finished picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickedByUserView.image = image
            imagePickedByUserView.contentMode = .scaleAspectFit
            activityButton?.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    // clear text field if it has default text (TOP or BOTTOM)
    func clearDefaultText(textField:UITextField, compare:String) {
        if textField.text == compare {
            textField.text = ""
        }
    }
    
    // when start editing text in text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.topMemeTextField {
            clearDefaultText(textField: textField, compare: KEY_TEXT_FIELD_TOP)
        } else if textField == self.bottomMemeTextField {
            clearDefaultText(textField: textField, compare: KEY_TEXT_FIELD_BOTTOM)
        }
    }
    
    // when return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

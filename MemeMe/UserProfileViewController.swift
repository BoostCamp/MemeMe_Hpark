//
//  TestViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeFirebaseValue()
        userNameField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUserProfileImageToFirebaseStorage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func observeFirebaseValue() {
        // get list of memePost from Firebase
        DataService.instance.REF_USER_CURRENT?.observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                if let username = value["username"] as? String {
                    self.userNameField.text = username
                }
                if let email = value["email"] as? String {
                    self.emailLabel.text = "Email : \(email)"
                }
        
                if let imageUrl = value["imageUrl"] as? String, let image = UIImage(named: imageUrl) {
                    self.userImage.image = image
                }
            }
        })
    }
    
    func setUserProfileImageToFirebaseStorage() {
        if let image = userImage.image, let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.instance.REF_ST_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(":::[HPARK] Unable to upload image to storage \(error):::\n ")
                } else {
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.saveUserProfileImageUrl(imageUrl: downloadURL)
                    }
                }
            }
        }
    }
    
    func saveUserProfileImageUrl (imageUrl: String) {
        if let currentUserRef = DataService.instance.REF_USER_CURRENT {
            currentUserRef.updateChildValues(["imageUrl": imageUrl])
        }
    }
    
    @IBAction func userImageTapped(_ sender: UITapGestureRecognizer) {
        presentImagePickerController(.photoLibrary)
    }
    

    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if userNameField.isFirstResponder {
            view.frame.origin.y = 64 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if userNameField.isFirstResponder {
            view.frame.origin.y = 64
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

//
//  SignInWithEmailViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidators
import SwiftKeychainWrapper

class SignInWithEmailViewController: UIViewController {
    
    struct Alerts {
        static let required = "비밀번호를 입력해주세요"
        static let notAllowed = "허용되지 않는 문자를 입력하셨습니다"
        static let wrong = "잘못된 이메일이나 비밀번호입니다"
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func presentAlert(controller: UIAlertController, message:String) {
        controller.message = message
        self.present(controller, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "사용자 로그인 경고", message: "With this", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        
        if let email = emailField.text, let password = passwordField.text {
            if Validators.isEmpty()(password) {
                presentAlert(controller: alert, message: Alerts.required)
                return
            }
            
            if !Validators.isASCII()(password) {
                presentAlert(controller: alert, message: Alerts.notAllowed)
                return
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print(":::[HPARK] Successfully signed in the app with email :::\n")
                    if let user = user, let email = user.email {
                        let dataUser = ["provider": user.providerID, "email": email]
                        DataService.instance.createFirebaseDatabaseUser(uid: user.uid, dataUser: dataUser)
                        KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    }
                    self.performSegue(withIdentifier: KEY_SEGUE_MEMES_DISPLAY_BY_EMAIL, sender: nil)
                } else {
                    print(":::[HPARK] Login failed with \(error) :::\n")
                    self.presentAlert(controller: alert, message: Alerts.wrong)
                }
            })
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if emailField.isFirstResponder || passwordField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if emailField.isFirstResponder || passwordField.isFirstResponder {
            view.frame.origin.y = 0
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

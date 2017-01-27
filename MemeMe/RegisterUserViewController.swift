//
//  RegisterUserViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import SwiftValidators

class RegisterUserViewController: UIViewController {

    struct Alerts {
        static let nameRequired = "사용자명을 입력해주세요"
        static let nameAlphanumeric = "영어와 숫자만 사용 가능합니다"
        static let nameMaxLength = "사용자명은 18자까지 쓸 수 있습니다"
        static let nameMinLength = "사용자명은 4자 이상으로 써주세요"
        static let required = "비밀번호를 입력해주세요"
        static let notAllowed = "허용되지 않는 문자를 입력하셨습니다"
        static let notSame = "작성하신 비밀번호가 동일하지 않습니다"
        static let maxLength = "비밀번호는 30자까지 쓸 수 있습니다"
        static let minLength = "비밀번호는 6자 이상으로 써주세요"
        static let wrong = "잘못된 이메일이나 비밀번호입니다"
        static let success = "회원가입을 축하합니다."
    }
    
    var alert: UIAlertController!
    var success: UIAlertController!
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.passwordConfirmField.delegate = self
        
        setAlerts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setAlerts() {
        alert = UIAlertController(title: "사용자 등록 경고", message: "With this", preferredStyle: .alert)
        success = UIAlertController(title: "회원가입 성공", message: "로그인 해주세요", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        success.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
    }

    func presentAlert(controller: UIAlertController, message:String) {
        controller.message = message
        self.present(controller, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
    
        // Username Validation
        if let userName = userNameField.text {
            if Validators.isEmpty()(userName) {
                presentAlert(controller: alert, message: Alerts.nameRequired)
                return
            }
            if !Validators.isAlphanumeric()(userName) {
                presentAlert(controller: alert, message: Alerts.nameAlphanumeric)
                return
            }
            if !Validators.maxLength(18)(userName) {
                presentAlert(controller: alert, message: Alerts.nameMaxLength)
                return
            }
            if !Validators.minLength(4)(userName) {
                presentAlert(controller: alert, message: Alerts.nameMinLength)
                return
            }
        } else {
            presentAlert(controller: alert, message: Alerts.nameRequired)
            return
        }
        
        if let email = emailField.text, let password = passwordField.text {
            
            if let passwordConfirm = passwordConfirmField.text {
                if Validators.isEmpty()(password) || Validators.isEmpty()(passwordConfirm) {
                    presentAlert(controller: alert, message: Alerts.required)
                    return
                }
                
                if !(Validators.isASCII()(password) && Validators.isASCII()(passwordConfirm)) {
                    presentAlert(controller: alert, message: Alerts.notAllowed)
                    return
                }
                if !Validators.equals(password)(passwordConfirm) {
                    presentAlert(controller: alert, message: Alerts.notSame)
                    return
                }
                if !Validators.maxLength(30)(password) {
                    presentAlert(controller: alert, message: Alerts.maxLength)
                    return
                }
                if !Validators.minLength(6)(password) {
                    presentAlert(controller: alert, message: Alerts.minLength)
                    return
                }
            } else {
                presentAlert(controller: alert, message: Alerts.required)
                return
            }
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(":::[HPARK] Unable to authenticate with email ::: \(error)\n")
                    self.presentAlert(controller: self.alert, message: Alerts.wrong)
                } else {
                    print(":::[HPARK] Successfully authenticated with email ::: \n")
                    self.presentAlert(controller: self.success, message: Alerts.success)
                }
            })
        }
    }
    
    // get keyboard height and shift the view from bottom to higher
    func keyboardWillShow(_ notification: Notification) {
        if passwordField.isFirstResponder || passwordConfirmField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if passwordField.isFirstResponder || passwordConfirmField.isFirstResponder {
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

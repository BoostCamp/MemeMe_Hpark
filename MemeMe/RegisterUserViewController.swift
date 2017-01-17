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

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "사용자 등록 경고", message: "With this", preferredStyle: .alert)
        let success = UIAlertController(title: "회원가입 성공", message: "로그인 해주세요", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        success.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        // Username Validation
        if let userName = userNameField.text {
            if Validators.isEmpty()(userName) {
                alert.message = "사용자명을 입력해주세요"
                self.present(alert, animated: true)
                return
            }
            
            if !Validators.isAlphanumeric()(userName) {
                alert.message = "영어와 숫자만 사용 가능합니다"
                self.present(alert, animated: true)
                return
            }
            
            if !Validators.maxLength(18)(userName) {
                alert.message = "사용자명은 18자까지 쓸 수 있습니다"
                self.present(alert, animated: true)
                return
            }
            
            if !Validators.minLength(4)(userName) {
                alert.message = "사용자명은 4자 이상으로 써주시길 바랍니다"
                self.present(alert, animated: true)
                return
            }
        } else {
            alert.message = "사용자명을 입력해주세요"
            self.present(alert, animated: true)
            return
        }
        
        // Password Validation
        if let password = passwordField.text {
            if let passwordConfirm = passwordConfirmField.text {
                if Validators.isEmpty()(password) || Validators.isEmpty()(passwordConfirm) {
                    alert.message = "비밀번호를 형식에 맞게 입력해주세요"
                    self.present(alert, animated: true)
                    return
                }
                
                if !(Validators.isASCII()(password) && Validators.isASCII()(passwordConfirm)) {
                    alert.message = "허용되지 않는 문자를 입력하셨습니다"
                    self.present(alert, animated: true)
                    return
                }
                if !Validators.equals(password)(passwordConfirm) {
                    alert.message = "작성하신 비밀번호가 동일하지 않습니다"
                    self.present(alert, animated: true)
                    return
                }
            } else {
                alert.message = "비밀번호를 형식에 맞게 입력해주세요"
                self.present(alert, animated: true)
                return
            }
        } else {
            alert.message = "비밀번호를 입력해주세요"
            self.present(alert, animated: true)
            return
        }
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    print(":::[HPARK] Unable to authenticate with email ::: \(error)\n")
                    alert.message = "회원가입 도중 오류가 발생하였습니다. 다시 시도하여주십시요"
                    self.present(alert, animated: true)
                } else {
                    print(":::[HPARK] Successfully authenticated with email ::: \n")
                    self.present(success, animated: true)
                }
            })
        }
    }
}

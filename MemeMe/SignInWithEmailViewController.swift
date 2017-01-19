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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "사용자 로그인 경고", message: "With this", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        
        // Password Validation
        if let password = passwordField.text {
            if Validators.isEmpty()(password) {
                alert.message = "비밀번호를 입력해주세요"
                self.present(alert, animated: true)
                return
            }
            
            if !Validators.isASCII()(password) {
                alert.message = "허용되지 않는 문자를 입력하셨습니다"
                self.present(alert, animated: true)
                return
            }
        } else {
            alert.message = "비밀번호를 입력해주세요"
            self.present(alert, animated: true)
            return
        }
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print(":::[HPARK] Successfully signed in the app with email :::\n")
                    if let user = user {
                        let dataUser = ["provider": user.providerID]
                        DataService.dataService.createFirebaseDatabaseUser(uid: user.uid, dataUser: dataUser)
                        KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    }
                    self.performSegue(withIdentifier: "wayToMemesDisplayByEmail", sender: nil)
                } else {
                    print(":::[HPARK] Login failed with \(error) :::\n")
                    alert.message = "잘못된 이메일이나 비밀번호입니다"
                    self.present(alert, animated: true)
                }
            })
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

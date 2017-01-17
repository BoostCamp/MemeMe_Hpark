//
//  SignInWithEmailViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SignInWithEmailViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginWithEmailButtonTapped(_ sender: Any) {
        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

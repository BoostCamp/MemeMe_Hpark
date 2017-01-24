//
//  RegisterUserViewController_ext.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension RegisterUserViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

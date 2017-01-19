//
//  CustomMemeTextField.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CustomMemeTextField: UITextField {

    let textFieldAtributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    override func draw(_ rect: CGRect) {
        self.defaultTextAttributes = textFieldAtributes
        self.textAlignment = .center
    }
}

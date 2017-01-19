//
//  CustomUserProfileImageView.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CustomUserProfileImageView: UIImageView {

    
    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
    }

}

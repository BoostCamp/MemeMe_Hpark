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
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0.1, height: 4.0)
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
    }

}

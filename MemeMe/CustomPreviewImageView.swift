//
//  CustomPreviewImageView.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CustomPreviewImageView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 
    func setBasicPreviewImageUI() {
        
    }
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0.1, height: 4.0)
        self.layer.shadowOpacity = 1.0
        self.layer.borderWidth = 1.4
        self.layer.borderColor = UIColor.white.cgColor
    }

}

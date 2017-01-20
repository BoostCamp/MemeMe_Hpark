//
//  MainPageTableViewCell.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

    var memePost: MemePost!
    
    @IBOutlet weak var userProfileImageView: CustomUserProfileImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var numberLikesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func establishCell(memePost: MemePost) {
        self.memePost = memePost
        self.numberLikesLabel.text = "\(memePost.likes)"
    }
}

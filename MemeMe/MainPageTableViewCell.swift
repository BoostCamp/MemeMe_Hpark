//
//  MainPageTableViewCell.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

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

    func establishCell(memePost: MemePost, image: UIImage? = nil) {
        self.memePost = memePost
        self.numberLikesLabel.text = "\(memePost.likes)"
        if let image = image{
            self.mainImageView.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: memePost.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print(":::[HPARK] Unable to Download image from Storage \(error):::")
                } else {
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.mainImageView.image = image
                            MainMemesDisplayViewController.imageCache.setObject(image, forKey: memePost.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}

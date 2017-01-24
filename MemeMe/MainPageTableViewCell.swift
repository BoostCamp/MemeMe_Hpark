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
    var likesReference: FIRDatabaseReference?
    
    @IBOutlet weak var userProfileImageView: CustomUserProfileImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var numberLikesLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func observeFirebaseValue() {
        if let keyUser = memePost.keyUser {
            print(keyUser)
            DataService.instance.REF_USERS.child(keyUser).observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, AnyObject> {
                    if let imageUrl = value["imageUrl"] as? String {
                        if let userImage = MainMemesDisplayViewController.imageCache.object(forKey: imageUrl as NSString) {
                            self.userProfileImageView.image = userImage
                        } else {
                            self.setImageFromFirebaseStorageWithUrl(imageUrl: imageUrl, isMainImage: false)
                        }
                    }
                }
            })
        }
    }
    
    func establishCell(memePost: MemePost, memeImage: UIImage? = nil) {
        self.memePost = memePost
        self.numberLikesLabel.text = "\(memePost.likes)명의 사람이 당신의 Meme을 좋아합니다"
        likesReference = DataService.instance.REF_USER_CURRENT?.child("likes").child(memePost.keyPost)
        if let memeImage = memeImage{
            self.mainImageView.image = memeImage
        } else {
            setImageFromFirebaseStorageWithUrl(imageUrl: memePost.imageUrl, isMainImage: true)
        }
        
        if let likesRef = likesReference {
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // something got from Firebase is JSON stuff, so it cannot be nil
                // need to check whether snapshot value is NSNull(null) or not
                if let _ = snapshot.value as? NSNull { // if the value is null
                    self.likesButton.setImage(UIImage(named: "Likes"), for: .normal)
                } else {
                    self.likesButton.setImage(UIImage(named: "Likes Tapped"), for: .normal)
                }
            })
        }
        
        observeFirebaseValue()
    }
    
    func setImageFromFirebaseStorageWithUrl(imageUrl: String, isMainImage:Bool) {
        let ref = FIRStorage.storage().reference(forURL: imageUrl)
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print(":::[HPARK] Unable to Download image from Storage \(error):::")
            } else {
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        if isMainImage {
                            self.mainImageView.image = image
                        } else {
                            self.userProfileImageView.image = image
                        }
                        MainMemesDisplayViewController.imageCache.setObject(image, forKey: imageUrl as NSString)
                    }
                }
            }
        })
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        if let likesRef = likesReference {
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull { // if the value is null
                    self.likesButton.setImage(UIImage(named: "Likes Tapped"), for: .normal)
                    self.memePost.changeLikesNumber(addLike: true)
                    likesRef.setValue(true)
                } else {
                    self.likesButton.setImage(UIImage(named: "Likes"), for: .normal)
                    self.memePost.changeLikesNumber(addLike: false)
                    likesRef.removeValue()
                }
            })
        }
    }
}

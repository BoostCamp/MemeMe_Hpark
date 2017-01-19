//
//  CustomMemeCollectionViewCell.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    func establishMemeCell(meme: Meme) {
        memeImageView.image = meme.memeImage as? UIImage
    }
}

//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var textTopLabel: UILabel!
    @IBOutlet weak var textBottomLabel: UILabel!
    
    func establishMemeCell(meme: Meme) {
        textTopLabel.text = meme.textTop
        textBottomLabel.text = meme.textBottom
        memeImageView.image = meme.memeImage as? UIImage
    }
}

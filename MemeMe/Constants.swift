//
//  Constants.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

struct IdForKeyChain {
    static let uid = "uid"
}

// initial word of top and bottom textfield in meme editor view controller
struct MemeTextPosition {
    static let top = "TOP"
    static let bottom = "BOTTOM"
}

// key for sorting in CoreData
struct IdForSort {
    static let byDate = "created"
}

struct IdForViewController {
    static let popUpNewPost = "popUpNewPost"
}

// key identifier for particular cell
struct IdForCell {
    static let memeTable = "MemeTableViewCell"
    static let memeCollection = "MemeCollectionViewCell"
    static let mainPageTable = "MainPageTableViewCell"
}

// key identifier for segueway
struct IdForSegue {
    static let displayMemes = "wayToMemesDisplay"
    static let displayMemesByEmail = "wayToMemesDisplayByEmail"
    static let userProfile = "wayToUserProfile"
    static let addMemes = "wayToAddNewMeme"
}

// Firebase references identifier
struct IdForFirebaseRef {
    static let databasePosts = "posts"
    static let databaseUsers = "users"
    static let storageImages = "post-images"
}

// Dictionary key - memePost model
struct IdForMemePost {
    static let caption = "caption"
    static let imageUrl = "imageUrl"
    static let user = "user"
    static let likes = "likes"
    static let dateTime = "dateTime"
}



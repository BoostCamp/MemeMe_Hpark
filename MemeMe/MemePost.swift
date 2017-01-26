//
//  MemePost.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import Firebase

class MemePost {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _keyPost: String!
    private var _dateTime: String!
    private var _keyUser: String?
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var keyPost: String {
        return _keyPost
    }
    
    var keyUser: String? {
        return _keyUser
    }
    
    var dateTime: String {
        return _dateTime
    }
    
    init(keyPost: String, dataPost: Dictionary<String, AnyObject>) {
        if let caption = dataPost[IdForMemePost.caption] as? String,
            let imageUrl = dataPost[IdForMemePost.imageUrl] as? String,
            let likes = dataPost[IdForMemePost.likes] as? Int,
            let keyUser = dataPost[IdForMemePost.user] as? String,
            let dateTime = dataPost[IdForMemePost.dateTime] as? String {
            self._caption = caption
            self._imageUrl = imageUrl
            self._likes = likes
            self._keyUser = keyUser
            self._dateTime = dateTime
            self._keyPost = keyPost
            _postRef = DataService.instance.REF_POSTS.child(_keyPost)
        }
    }
    
    func changeLikesNumber(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }
}

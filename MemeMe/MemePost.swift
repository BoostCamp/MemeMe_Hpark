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
    
    init(caption: String, imageUrl:String, likes: Int, comments: Array< Dictionary< String, String> >) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(keyPost: String, dataPost: Dictionary<String, AnyObject>) {
        self._keyPost = keyPost
        if let caption = dataPost[KEY_DIC_POST_CAPTION] as? String {
            self._caption = caption
        }
        
        if let imageUrl = dataPost[KEY_DIC_POST_IMAGE_URL] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = dataPost[KEY_DIC_POST_LIKES] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.instance.REF_POSTS.child(_keyPost)
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

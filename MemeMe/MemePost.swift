//
//  MemePost.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

class MemePost {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _keyPost: String!
    private var _comments: Array< Dictionary< String, String> >!
    
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
    
    var comments: Array< Dictionary< String, String> > {
        return _comments
    }
    
    init(caption: String, imageUrl:String, likes: Int, comments: Array< Dictionary< String, String> >) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._comments = comments
    }
    
    init(keyPost: String, dataPost: Dictionary<String, AnyObject>) {
        self._keyPost = keyPost
        if let caption = dataPost["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = dataPost["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = dataPost["likes"] as? Int {
            self._likes = likes
        }
        
        if let comments = dataPost["comments"] as? Array< Dictionary< String, String> > {
            self._comments = comments
        }
    }
}

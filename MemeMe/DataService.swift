//
//  DataService.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    static let instance = DataService()
    
    // Database References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child(KEY_DATABASE_POSTS)
    private var _REF_USERS = DB_BASE.child(KEY_DATABASE_USERS)
    
    // Storage References
    private var _REF_ST_POST_IMAGES = STORAGE_BASE.child(KEY_STORAGE_POST_IMAGES)
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_ST_POST_IMAGES: FIRStorageReference {
        return _REF_ST_POST_IMAGES
    }
    
    func createFirebaseDatabaseUser(uid: String, dataUser: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(dataUser)
    }
}

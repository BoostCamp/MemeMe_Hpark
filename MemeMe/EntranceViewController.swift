//
//  ViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import FBSDKCoreKit
import FBSDKLoginKit

import SwiftKeychainWrapper

class EntranceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        // KeychainWrapper.standard.remove(key: KEY_UID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "wayToMemesDisplay", sender: nil)
        }
    }
    
    // Open Facebook Login Manager in order to get credential from it
    @IBAction func loginWithFacebookButtonTapped(_ sender: Any) {
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(":::[HPARK] Unable to authenticate with Facebook \(error):::\n")
            } else if result?.isCancelled == true {
                print(":::[HPARK] App User cancelled Facebook Authentication :::\n")
            } else {
                print(":::[HPARK] Authentication with Facebook Successful :::\n")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // After getting Facebook credential, sign in MemeMe App with the credential got from facebook login manager
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(":::[HPARK] Unable to authenticate with Firebase - \(error) :::\n")
            } else {
                print(":::[HPARK] Successfully authenticated with Firebase :::\n")
                if let user = user {
                    let dataUser = ["provider": credential.provider]
                    DataService.dataService.createFirebaseDatabaseUser(uid: user.uid, dataUser: dataUser)
                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                }
                self.performSegue(withIdentifier: "wayToMemesDisplay", sender: nil)
            }
        })
    }



}


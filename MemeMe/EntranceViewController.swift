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

class EntranceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    }


}


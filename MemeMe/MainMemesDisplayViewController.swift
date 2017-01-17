//
//  MainMemesDisplayViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class MainMemesDisplayViewController: UIViewController {
    
    @IBOutlet weak var newPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        newPostButton.isEnabled = false
    }
    
    @IBAction func newPostButtonTapped(_ sender: Any) {
        let popOverNewPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpNewPost") as! PopupNewPostViewController
        self.addChildViewController(popOverNewPostViewController)
        popOverNewPostViewController.view.frame = self.view.frame
        self.view.addSubview(popOverNewPostViewController.view)
        popOverNewPostViewController.didMove(toParentViewController: self)
    }
}

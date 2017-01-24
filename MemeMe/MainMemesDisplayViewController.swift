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
import CoreData


class MainMemesDisplayViewController: UIViewController {
    
    var memePosts = [MemePost]()
    
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var memesDisplayTableView: UITableView!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        
        self.memesDisplayTableView.delegate = self
        self.memesDisplayTableView.dataSource = self
        
        // get list of memePost from Firebase
        DataService.instance.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.memePosts.removeAll()
                for one in snapshot {
                    print("[VAL]: \(one)")
                    if let postDict = one.value as? Dictionary<String, AnyObject> {
                        let key = one.key
                        let memePost = MemePost(keyPost: key, dataPost: postDict)
                        self.memePosts.append(memePost)
                    }
                }
            }
            self.memesDisplayTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setNavigationBarUI() {
        // logo image
        let logo = UIImage(named: "Meme Home Logo")
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        
        // nav bar style
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 213/255, blue: 241/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        // nav bar no border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func menuBarButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func newPostButtonTapped(_ sender: Any) {
        let popOverNewPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpNewPost") as! PopupNewPostViewController
        self.addChildViewController(popOverNewPostViewController)
        popOverNewPostViewController.view.frame = CGRect(x: 0, y: -26, width: view.frame.size.width, height: view.frame.size.height + 26)
        self.view.addSubview(popOverNewPostViewController.view)
        popOverNewPostViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "openUserProfile", sender: nil)
    }
}

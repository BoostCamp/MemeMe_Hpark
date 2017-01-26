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
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var memePosts = [MemePost]()
    
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var memesDisplayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        
        self.memesDisplayTableView.delegate = self
        self.memesDisplayTableView.dataSource = self
        
        observeFirebaseValue()
    }
    
    func observeFirebaseValue() {
        // get list of memePosts from Firebase
        DataService.instance.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.memePosts.removeAll()
                for one in snapshot {
                    if let postDict = one.value as? Dictionary<String, AnyObject> {
                        let key = one.key
                        let memePost = MemePost(keyPost: key, dataPost: postDict)
                        self.memePosts.append(memePost)
                    }
                }
            }
            self.memePosts.reverse()
            self.memesDisplayTableView.reloadData()
        })
    }
    
    func setNavigationBarUI() {
        // logo image
        let logo = UIImage(named: "Meme Home Logo")
        let logoImageView = UIImageView(image: logo)
        self.navigationItem.titleView = logoImageView
        
        // nav bar style
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 213/255, blue: 241/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        // nav bar without border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func menuBarButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: IdForKeyChain.uid)
        do {
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            let error = error as NSError
            print(":::[HPARK] Sign Out Failure \(error) :::\n")
        }
    }

    @IBAction func newPostButtonTapped(_ sender: Any) {
        let popOverNewPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: IdForViewController.popUpNewPost) as! PopupNewPostViewController
        self.addChildViewController(popOverNewPostViewController)
        popOverNewPostViewController.view.frame = CGRect(x: 0, y: -24, width: view.frame.size.width, height: view.frame.size.height + 24)
        self.view.addSubview(popOverNewPostViewController.view)
        popOverNewPostViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: IdForSegue.userProfile, sender: nil)
    }
}

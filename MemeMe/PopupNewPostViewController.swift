//
//  PopupNewPostViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class PopupNewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func closePostButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}

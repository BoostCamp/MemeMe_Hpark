//
//  MainMemesDisplayViewController_ext.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 20..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension MainMemesDisplayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memePost = memePosts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: KEY_MAIN_TABLE_CELL) as? MainPageTableViewCell {
            cell.establishCell(memePost: memePost)
            return cell
        } else {
            return MainPageTableViewCell()
        }
    }
}

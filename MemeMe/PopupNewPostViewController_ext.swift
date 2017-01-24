//
//  PopupNewPostViewController_ext.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 19..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import CoreData

extension PopupNewPostViewController: UITableViewDelegate, UITableViewDataSource {
    func establishMemeCell(cell: MemeTableViewCell, indexPath: IndexPath) {
        let meme = self.memeController.object(at: indexPath)
        cell.establishMemeCell(meme: meme)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memeTableView.dequeueReusableCell(withIdentifier: KEY_MEME_TABLE_CELL, for: indexPath) as! MemeTableViewCell
        establishMemeCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // when selected particular cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = memeController.fetchedObjects , objs.count > 0 {
            self.isImageSelected = true
            let meme = objs[indexPath.row]
            self.previewImage.image = meme.memeImage as! UIImage?
            self.memeToDelete = meme
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = memeController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = memeController.sections {
            return sections.count
        }
        return 0
    }
}


extension PopupNewPostViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memeTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memeTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                memeTableView.insertRows(at: [indexPath], with: .fade)
                memeCollectionView.insertItems(at: [indexPath])
            }
            break
        case .delete:
            if let indexPath = indexPath {
                memeTableView.deleteRows(at: [indexPath], with: .fade)
                memeCollectionView.deleteItems(at: [indexPath])
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = memeTableView.cellForRow(at: indexPath) as! MemeTableViewCell
                establishMemeCell(cell: cell, indexPath: indexPath)
                let cellCollection = memeCollectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
                let meme = self.memeController.object(at: indexPath)
                cellCollection.establishMemeCell(meme: meme)
            }
            break
        case .move:
            if let indexPath = indexPath {
                memeTableView.deleteRows(at: [indexPath], with: .fade)
                memeCollectionView.deleteItems(at: [indexPath])
            }
            if let indexPath = newIndexPath {
                memeTableView.insertRows(at: [indexPath], with: .fade)
                memeCollectionView.insertItems(at: [indexPath])
            }
            break
        }
    }
}

extension PopupNewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = memeController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memeCollectionView.dequeueReusableCell(withReuseIdentifier: KEY_MEME_COLLECTION_CELL, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memeController.object(at: indexPath)
        cell.establishMemeCell(meme: meme)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = self.preCollectionIndexPath {
            let preSelectedCell = collectionView.cellForItem(at: index) as! MemeCollectionViewCell
            preSelectedCell.layer.borderWidth = 0.0
        }
        
        let newlySelectedCell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
    
        newlySelectedCell.layer.borderWidth = 1.8
        newlySelectedCell.layer.borderColor = UIColor.red.cgColor
        self.preCollectionIndexPath = indexPath
        
        self.previewImage.image = newlySelectedCell.memeImageView.image
        
        if let objs = memeController.fetchedObjects, objs.count > 0 {
            self.isImageSelected = true
            let meme = objs[indexPath.row]
            self.memeToDelete = meme
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = memeController.sections else {
            return 0
        }
        return sections.count
    }
}

extension PopupNewPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
    
        if newText.length > 80 {
            self.textLengthLabel.textColor = UIColor.red
            self.memeIntroTextField.text = newText.substring(to: 79)
        } else {
            self.textLengthLabel.textColor = UIColor.darkGray
        }
        
        // Write the length of newText into the label
        self.textLengthLabel.text = "\(String(newText.length)) / 80 자"
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.memeIntroTextField.resignFirstResponder()
        return true
    }
}

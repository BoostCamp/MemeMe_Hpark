//
//  PopupNewPostViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import CoreData

class PopupNewPostViewController: UIViewController {

    var memeController: NSFetchedResultsController<Meme>!
    
    @IBOutlet weak var addPostToolbar: UIToolbar!
    @IBOutlet weak var memeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.memeTableView.delegate = self
        self.memeTableView.dataSource = self
        fetchAllMeme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fetchAllMeme() {
        let fetchRequest: NSFetchRequest<Meme> = Meme.fetchRequest()
        let sortByDate = NSSortDescriptor(key: KEY_SORT_DATA_BY_DATE, ascending:true)
        fetchRequest.sortDescriptors = [sortByDate]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.memeController = controller
        
        do {
            try controller.performFetch()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    @IBAction func closePostButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func addMemeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addNewMeme", sender: nil)
    }
}

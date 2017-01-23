//
//  PopupNewPostViewController.swift
//  MemeMe
//
//  Created by connect on 2017. 1. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class PopupNewPostViewController: UIViewController {
    
    var memeToDelete: Meme?
    var preTableIndexPath: IndexPath?
    var preCollectionIndexPath: IndexPath?
    var memeController: NSFetchedResultsController<Meme>!
    var isImageSelected: Bool = false
    
    @IBOutlet weak var addPostToolbar: UIToolbar!
    @IBOutlet weak var memeTableView: UITableView!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var textLengthLabel: UILabel!
    @IBOutlet weak var memeIntroTextField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var previewImage: CustomPreviewImageView!
    @IBOutlet weak var userImage: CustomUserProfileImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopViewUI()
        setCollectionViewUI()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.memeTableView.delegate = self
        self.memeTableView.dataSource = self
        
        self.memeCollectionView.delegate = self
        self.memeCollectionView.dataSource = self
        
        self.memeIntroTextField.delegate = self
        
        fetchAllMeme()
        
        memeCollectionView.isHidden = true
        tableButton.setImage(UIImage(named:"icon table picked"), for: .normal)
        previewImage.setBasicPreviewImageUI()
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
    
    func setPopViewUI() {
        self.popupView.layer.cornerRadius = 20.0
    }
    
    func setCollectionViewUI() {
        let interItemSpace: CGFloat = 0.0
        let lineSpace: CGFloat = 0.0
        
        let demensionWidth = (popupView.frame.size.width) / 4.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpace
        collectionViewFlowLayout.minimumLineSpacing = lineSpace
        collectionViewFlowLayout.itemSize = CGSize(width: demensionWidth, height: demensionWidth)
    }
    
    @IBAction func closePostButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func addMemeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addNewMeme", sender: nil)
    }
    
    @IBAction func tableButtonTapped(_ sender: Any) {
        memeTableView.isHidden = false
        memeCollectionView.isHidden = true
        tableButton.setImage(UIImage(named:"icon table picked"), for: .normal)
        collectionButton.setImage(UIImage(named:"icon collection"), for: .normal)
    }
    
    @IBAction func collectionButtonTapped(_ sender: Any) {
        memeTableView.isHidden = true
        memeCollectionView.isHidden = false
        tableButton.setImage(UIImage(named:"icon table"), for: .normal)
        collectionButton.setImage(UIImage(named:"icon collection picked"), for: .normal)
    }
    
    @IBAction func trashButtonClicked(_ sender: Any) {
        if self.memeToDelete != nil {
            context.delete(self.memeToDelete!)
            appDelegate.saveContext()
            memeTableView.reloadData()
            memeCollectionView.reloadData()
        }
    }
    
    @IBAction func addMemePostButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "포스팅 경고", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in })
        
        guard let caption = memeIntroTextField.text, caption != "" else {
            alert.message = "메세지를 작성해주세요 ^^"
            self.present(alert, animated: true)
            return
        }
        guard let image = previewImage.image, isImageSelected == true else {
            alert.message = "사진을 선택해주세요 ^^"
            self.present(alert, animated: true)
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.instance.REF_ST_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(":::[HPARK] Unable to upload image to storage \(error):::\n ")
                } else {
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.memePostToFirebase(imageUrl: downloadURL)
                        self.view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func memePostToFirebase(imageUrl: String) {
        let memePost: Dictionary<String, AnyObject> = [
            KEY_DIC_POST_CAPTION: memeIntroTextField.text! as AnyObject,
            KEY_DIC_POST_IMAGE_URL: imageUrl as AnyObject,
            KEY_DIC_POST_LIKES: 0 as AnyObject,
        ]
        
        let firebasePost = DataService.instance.REF_POSTS.childByAutoId()
        firebasePost.setValue(memePost)
        
        self.isImageSelected = false
    }
    
}

//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sergey Kravtsov on 17.08.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MemeEditViewControllerDelegate {

    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var memes = [Meme]()

    let cellIdentifier = "memeCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.allowsMultipleSelection = false
        //configureFlowLayout(3.0)
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // tab bar after detailVC
        tabBarController?.tabBar.hidden = false

        UIApplication.sharedApplication().statusBarHidden = false
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.memeImageView.image = meme.memedImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func dismissMemeEditViewController() {
        dismissViewControllerAnimated(true) {
            self.collectionView.reloadData()
        }
    }
    
    /*func configureFlowLayout(space: CGFloat) {
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }*/
   
    // Sugues identifiers
    let SegueToMemeEditor = "segueToMemeEdit"
    let SegueToMemeDetail = "segueToMemeDetail"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SegueToMemeEditor {
            if let destination = segue.destinationViewController as? UINavigationController, memeEditVC = destination.topViewController as? MemeEditViewController {
                memeEditVC.delegate = self
            }
        } else if segue.identifier == SegueToMemeDetail {
            if let destination = segue.destinationViewController as? MemeDetailViewController, arrayOfIndexPaths = collectionView.indexPathsForSelectedItems(), indexPath = arrayOfIndexPaths.first {
                let selectedCell = memes[indexPath.item]
                destination.meme = selectedCell
            }
        }
    }
}

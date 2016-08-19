//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Sergey Kravtsov on 17.08.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MemeEditViewControllerDelegate {
    
    
    let cellIdentifier = "memeTableViewCell"
    
    var memes = [Meme]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // tab bar after detailVC
        tabBarController?.tabBar.hidden = false

        UIApplication.sharedApplication().statusBarHidden = false
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeLabel.text = "\(meme.topText!)...\(meme.bottomText!)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Delete Meme
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) in
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            self.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
        return [button]
    }
    
    
    func dismissMemeEditViewController() {
        dismissViewControllerAnimated(true) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Sugue
    let SegueToMemeEdit = "segueToMemeEdit"
    let SegueToMemeDetail = "segueToMemeDetail"
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SegueToMemeEdit {
            if let destination = segue.destinationViewController as? UINavigationController, memeEditVC = destination.topViewController as? MemeEditViewController {
                memeEditVC.delegate = self
            }
        } else if segue.identifier == SegueToMemeDetail {
            if let destination = segue.destinationViewController as? MemeDetailViewController, indexPath = tableView.indexPathForSelectedRow {
                let selectedCell = memes[indexPath.row]
                destination.meme = selectedCell
            }
        }
    }
}

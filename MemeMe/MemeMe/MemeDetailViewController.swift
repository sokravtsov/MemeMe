//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sergey Kravtsov on 17.08.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Detail"
        
        imageView.image = meme?.memedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = true
    }
    
}
//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Sergey Kravtsov on 07.07.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

protocol MemeEditViewControllerDelegate: class {
    func dismissMemeEditViewController()
}

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,  PickFontProtocol {
    
    weak var delegate: MemeEditViewControllerDelegate?
    
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var fontSelectorButton: UIBarButtonItem!
    
    var globalFontValue = "Impact"
    var priorKeyboardHeight: CGFloat = 0.0
    
    
    // canecel Meme
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Change font
    @IBAction func performFontSelectorButton(sender: UIBarButtonItem) {
        var controller: PickFontViewController
        
        controller  = storyboard?.instantiateViewControllerWithIdentifier("FontSelectorVC") as! PickFontViewController
        controller.m_currentFont = globalFontValue
        controller.delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        setToInitialState()

       
        // List all available font names
        for family: String in UIFont.familyNames() {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family) {
                print("== \(names)")
            }
        }
        
        UIApplication.sharedApplication().statusBarHidden = true

    }
    
    // hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // MARK: Pick image
    // album button
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentImagePickerView(.PhotoLibrary)
    }
    
    // camera button
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        presentImagePickerView(.Camera)
    }
    
    // present image picker view
    func presentImagePickerView(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // dimiss image picker view when user select a still image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // display the original image to UIImageView box
        if let userSelectedImageVal = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickView.image = userSelectedImageVal
            imagePickView.contentMode = .ScaleAspectFit
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // dimiss image picker view when user hit cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setTextField(textField: UITextField, placeHolderText: String) {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor .blackColor(),
            NSForegroundColorAttributeName : UIColor .whiteColor(),
            NSFontAttributeName : UIFont(name: globalFontValue, size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textField.text = placeHolderText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
        
    }
    
   
    // MARK: Initial state
    func setToInitialState() {
        shareButton.enabled = false
        memeView.backgroundColor = UIColor.darkGrayColor()
        imagePickView.image = nil
        globalFontValue = "Impact"
        
        // Initial Font will always be impact
        setTextField(topTextField, placeHolderText: "TOP")
        setTextField(bottomTextField, placeHolderText: "BOTTOM")
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if ((textField.text == "TOP") || (textField.text == "BOTTOM"))
        {
            textField.text = ""
        }
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField == topTextField {
                textField.text = "TOP"
            } else if textField == bottomTextField {
                textField.text = "BOTTOM"
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // check if camera is avaiable on the device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // sign up to to be notified when keyboard appears
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe keyboard notification
        unsubscribeFromKeyboardNotifications()
    }

    
    // MARK: Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0//+= getKeyboardHeight(notification)
        }
    }
    
    // get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // observe keyboard notifications
    func subscribeKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // remove keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: Share MemeMe
    @IBAction func share(sender: UIBarButtonItem) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [AnyObject]?, error: NSError? ) in
            // return if cancelled
            if (!completed) {
                return
            } else {
                self.save(image)
                self.delegate?.dismissMemeEditViewController()
            }
        }
        
        presentViewController(controller, animated: true, completion: nil)

    }
    
    // create Meme object
    func save(memedImage: UIImage) {
        
        if let topText = topTextField.text, bottomText = bottomTextField.text, image = imagePickView.image {
            let meme = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
            
            // Add meme to memes array in the AppDelegate
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        // hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        toolBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navigationController?.navigationBarHidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    // MARK: Update font
    func updateFont(newFontValue: String) {
        globalFontValue = newFontValue
        print("THE FOLLOWING FONT WAS SELECTED AND NOW UPDATE \(globalFontValue)")
        setTextField(topTextField, placeHolderText: topTextField.text!)
        setTextField(bottomTextField, placeHolderText: bottomTextField.text!)

    }
}
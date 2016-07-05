//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Laura Scully on 25/6/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UITextFieldDelegate, UINavigationControllerDelegate {
    
    var memeIndex:Int!
    var existingMeme: Meme!
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickImageBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAttrs = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Arial Rounded MT Bold", size: 40)!,
        NSStrokeWidthAttributeName: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        shareBtn.enabled = false
        setToEditorView()
        initializeTextField(topText)
        initializeTextField(bottomText)
    }
    
    func initializeTextField(textField:UITextField){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttrs
        textField.textAlignment = .Center
    }
    
    func setToEditorView(){
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        image.image = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.tabBarController?.tabBar.hidden = true
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
        
        if (existingMeme != nil) {
         shareBtn.enabled = true
         image.image = existingMeme.image
         topText.text = existingMeme.topText
         bottomText.text = existingMeme.bottomText
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }

    func keyboardWillShow(notification: NSNotification){
        if (bottomText.isFirstResponder()){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func getKeyboardHeight(notification: NSNotification)-> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        let source:UIImagePickerControllerSourceType = {
            if(sender as! NSObject == self.cameraBtn){
             return UIImagePickerControllerSourceType.Camera
            }else{
            return UIImagePickerControllerSourceType.PhotoLibrary
            }
        }()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated:true, completion:nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            existingMeme = nil
            image.image = selectedImage
            shareBtn.enabled  = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.hidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden = false
        return memedImage
    }
    
    func goToSentMeme(){
        if let initialViewController = self.navigationController?.viewControllers[0] {
            self.navigationController?.popToViewController(initialViewController, animated: true)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        goToSentMeme()
    }
    
    @IBAction func shareMeme(sender:AnyObject){
        let memedImage =  generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
        
        nextController.completionWithItemsHandler = {(activityType, completed:Bool,
            returnedObjects:[AnyObject]?, error:NSError?) in
            
            if completed {
                let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!,
                            image: self.image.image!, memedImage: memedImage)
                self.image.image = memedImage
                    if (self.memeIndex != nil) {
                        self.appDelegate.memes[self.memeIndex] = meme
                    }else{
                        self.appDelegate.memes.append(meme)
                    }
                self.goToSentMeme()
            
            }
        }

    }
}



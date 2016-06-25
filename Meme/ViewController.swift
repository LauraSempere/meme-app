//
//  ViewController.swift
//  Meme
//
//  Created by Laura Scully on 25/6/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var pickImageBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var activeTextField:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttrs = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.yellowColor(),
            NSFontAttributeName : UIFont(name: "Arial Rounded MT Bold", size: 40)!,
            NSStrokeWidthAttributeName: -1
        ]
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareBtn.enabled = false
        topText.delegate = self
        bottomText.delegate = self
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.defaultTextAttributes = memeTextAttrs
        bottomText.defaultTextAttributes = memeTextAttrs
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func setToEditorView(){
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        image.image = nil
    }
    
    func keyboardWillShow(notification: NSNotification){
        if (activeTextField == "bottomText")
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)}
      
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
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
        activeTextField = textField.restorationIdentifier!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getSourceType(tag: Int?) -> UIImagePickerControllerSourceType{
        if tag == 0 {
            return UIImagePickerControllerSourceType.PhotoLibrary
        }else{
            return UIImagePickerControllerSourceType.Camera
        }
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = getSourceType(sender.tag)
        self.presentViewController(imagePicker, animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image.image = selImage
            shareBtn.enabled  = true
        }
        //self.setToEditorView()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
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
    
    @IBAction func cancel(sender: AnyObject) {
        setToEditorView()
    }
    
    @IBAction func shareMeme(sender:AnyObject){
        let memedImage =  generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
        
        nextController.completionWithItemsHandler = {(activityType, completed:Bool,
            returnedObjects:[AnyObject]?, error:NSError?) in
            
            let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!,
                            image: self.image.image!, memedImage: memedImage)
            self.image.image = memedImage
            self.setToEditorView()
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
}



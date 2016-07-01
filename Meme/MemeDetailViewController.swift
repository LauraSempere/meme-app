//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Laura Scully on 1/7/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var memeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MemeDetailViewController.editMeme))
        memeImage.image = meme.image
    }

    func editMeme(){
        let editorNavVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
        let editorVC =  storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorVC.meme = meme
        
        self.presentViewController(editorNavVC, animated: true, completion: nil)
    }
}

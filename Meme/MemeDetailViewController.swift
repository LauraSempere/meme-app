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
    var memeIndex: Int!
    
    @IBOutlet weak var memeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MemeDetailViewController.editMeme))
        memeImage.image = meme.memedImage
    }

    func editMeme(){
        let editorVC =  storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorVC.memeIndex = memeIndex
        editorVC.existingMeme = meme
        self.navigationController?.pushViewController(editorVC, animated: true)
    }
}

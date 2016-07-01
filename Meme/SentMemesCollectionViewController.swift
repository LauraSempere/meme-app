//
//  SentMemesCollectionViewController.swift
//  Meme
//
//  Created by Laura Scully on 1/7/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit


class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 6
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(SentMemesCollectionViewController.goToEditMeme))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.collectionView!.reloadData()
    }
    
     func goToEditMeme(){
        let editMemeVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        self.navigationController?.pushViewController(editMemeVC, animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.item]
        cell.image.image = meme.memedImage

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.item]
        detailVC.meme = meme
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

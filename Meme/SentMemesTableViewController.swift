//
//  SentMemesTableViewController.swift
//  Meme
////  Created by Laura Scully on 30/6/2016.
//  Copyright © 2016 laura.com. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes:[Meme]!
    let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = applicationDelegate.memes

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(SentMemesTableViewController.goToEditMeme))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.tableView.reloadData()
    }
    
    func goToEditMeme(){
    let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
    self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")!
        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.row]
        detailVC.meme = meme
        detailVC.memeIndex = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tableView.beginUpdates()
            applicationDelegate.memes.removeAtIndex(indexPath.row)
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
}

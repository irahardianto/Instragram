//
//  homeVC.swift
//  Instragram
//
//  Created by Pagers on 4/10/16.
//  Copyright © 2016 irahardianto. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"

class homeVC: UICollectionViewController {

    // define refresher
    var refreshers: UIRefreshControl!
    
    // size of the page
    var page: Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        collectionView?.backgroundColor = .whiteColor()
    
        // title at the top
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
        // pull to refresh
        refreshers = UIRefreshControl()
        refreshers.addTarget(self, action: #selector(homeVC.refresher), forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refreshers)
        
        // load posts
        loadPosts()
    }
    
    // refresh function
    func refresher() {
        
        // reload data
        collectionView?.reloadData()
        
        // stop refresher animation
        refreshers.endRefreshing()
    }
    
    // load posts
    func loadPosts() {
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                
                // find object related to array (holders)
                for object in objects! {
                    
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                
                print(error!.localizedDescription)
            }
        }
    }

    // number of cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picArray.count * 20
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // cell config
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        // get picture from picArray
        picArray[0].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            
            if error == nil {
                
                cell.picImg.image = UIImage(data: data!)
            } else {
                
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    
    // header config
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        // get user's data with the connections to columns of PFuser class
        header.fullnameLbl.text = (PFUser.currentUser()!.objectForKey("fullname") as? String)?.uppercaseString
        header.webTxt.text = PFUser.currentUser()?.objectForKey("web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.bioLbl.sizeToFit()
        header.button.setTitle("edit profile", forState: .Normal)
        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            
            header.avaImg.image = UIImage(data: data!)
        }
        
        return header
    }
    
    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        
    
        return cell
    }
    */
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

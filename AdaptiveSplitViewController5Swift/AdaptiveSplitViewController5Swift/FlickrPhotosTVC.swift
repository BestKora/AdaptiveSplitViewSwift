//
//  FlickrPhotosTVC.swift
//  AdaptiveSplitViewController1Swift
//
//  Created by Tatiana Kornilova on 2/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class FlickrPhotosTVC: UITableViewController {
    var photos = [Photo]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "photoCell"
        static let SegueIdentifierPhoto = "Show Photo"
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return photos.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier,
                forIndexPath: indexPath)
            let photo = photos[indexPath.row]
            cell.textLabel?.text = photo.title
            cell.detailTextLabel?.text = photo.subtitle
            return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SegueIdentifierPhoto {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let photo = photos[indexPath.row]
                
                var destination = segue.destinationViewController
                if let nc = destination as? UINavigationController,
                    let visibleVC = nc.visibleViewController {
                        destination = visibleVC
                        destination.navigationItem.leftBarButtonItem =
                                     self.splitViewController?.displayModeButtonItem()
                        destination.navigationItem.leftItemsSupplementBackButton = true
                        
                }
                guard let controller = destination as? ImageViewController
                    else {return }
                
                controller.imageURL = NSURL(string: photo.imageURL)
                controller.title = photo.title
            }
        }
    }
}




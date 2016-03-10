//
//  FlickrPhotographersTVC.swift
//  AdaptiveSplitViewController2Swift
//
//  Created by Tatiana Kornilova on 2/20/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class FlickrPhotographersTVC: UITableViewController {
    
    var photos = [Photo]() {
        didSet{
            let photographerNames =
            Array(Set( photos.flatMap{$0.photographer == "" ? nil : $0.photographer})).sort()
            photographers =
                photographerNames.flatMap{Photographer.init(name: $0, allPhotos: photos)}
                   }
    }
    
    private (set) var photographers = [Photographer]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "photographerCell"
        static let SegueIdentifierPhoto = "Show List Photos"
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return photographers.count
    }
    
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier,
                forIndexPath: indexPath)
            let photographer = photographers[indexPath.row]
            cell.textLabel?.text = photographer.name
            cell.detailTextLabel?.text = "фотографий \(photographer.photos.count)"
            return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SegueIdentifierPhoto {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let photographer = photographers[indexPath.row]
                
                var destination = segue.destinationViewController
                if let nc = destination as? UINavigationController {
                    destination = nc.visibleViewController!
                    destination.navigationItem.leftBarButtonItem =
                        self.splitViewController?.displayModeButtonItem()
                    destination.navigationItem.leftItemsSupplementBackButton = true
                    
                }
                if let controller = destination as? FlickrPhotosTVC {
                    controller.photos = photographer.photos
                    controller.title = photographer.name
                }
            }
        }
    }
}

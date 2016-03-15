//
//  JustPostedFlickrPhotosTVC.swift
//  AdaptiveSplitViewController1Swift
//
//  Created by Tatiana Kornilova on 2/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit
import CoreData

class JustPostedFlickrPhotosTVC: PhotosCDTVC {
    var coreDataStack: CoreDataStack! {
        didSet {
             fetchPhotos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   fetchPhotos()
    }
    
    @IBAction func fetchPhotos(){
        self.refreshControl?.beginRefreshing()
        
        self.setupFetchedResultsController(coreDataStack.managedObjectContext)
        let url = FlickrFetcher.URLforRecentGeoreferencedPhotos()
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) {(localURL, response, error) in
            guard error == nil else {return}
            
            // получаем массив словарей для фотографий с Flickr
            guard let url = localURL,
                let data = NSData(contentsOfURL: url),
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments),
                let flickrPhotos = json.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as? [[String : AnyObject]]
                else { return}
            
            dispatch_async(dispatch_get_main_queue()){
                self.refreshControl?.endRefreshing()
                
                // Записываем в Core Data
                _ = flickrPhotos.flatMap({ (dict) -> Photo? in
                    return Photo.init(dictionary: dict, context: self.coreDataStack.managedObjectContext)
                })
                self.coreDataStack.saveMainContext()
            }
        }
        task.resume()
    }
    
    func setupFetchedResultsController(context:NSManagedObjectContext) {
        
            let request = NSFetchRequest(entityName: "Photo")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: "localizedStandardCompare:")]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
    }

}

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
    var photos = [[String:AnyObject]]()
    lazy var coreDataStack = CoreDataStack()
    lazy var context:NSManagedObjectContext = self.coreDataStack.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    @IBAction func fetchPhotos(){
        self.refreshControl?.beginRefreshing()
        
        self.setupFetchedResultsController(self.context)
        let url = FlickrFetcher.URLforRecentGeoreferencedPhotos()
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) {
            (localURL, response, error) in
            guard error == nil else {return}
            
            // получаем массив словарей для фотографий с Flickr
            guard let data = NSData(contentsOfURL: localURL!),
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments),
                let flickrPhotos = json.valueForKeyPath(FLICKR_RESULTS_PHOTOS)as? [[String : AnyObject]]
                else { return}
            
            // сохраняем
           self.photos = flickrPhotos
           
            
            dispatch_async(dispatch_get_main_queue()){
                
                self.refreshControl?.endRefreshing()
                
                // Записываем в Core Data
                Photo.loadPhotosFromFlickr(self.photos, context: self.context)
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

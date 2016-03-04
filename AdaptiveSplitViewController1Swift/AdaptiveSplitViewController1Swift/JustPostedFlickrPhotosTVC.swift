//
//  JustPostedFlickrPhotosTVC.swift
//  AdaptiveSplitViewController1Swift
//
//  Created by Tatiana Kornilova on 2/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class JustPostedFlickrPhotosTVC: FlickrPhotosTVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    @IBAction func fetchPhotos(){
        self.refreshControl?.beginRefreshing()
        
        let url = FlickrFetcher.URLforRecentGeoreferencedPhotos()
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) {
            (localURL, response, error) in
            guard error == nil else {return}
            
            // получаем массив словарей для фотографий с Flickr
            guard let data = NSData(contentsOfURL: localURL!),
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments),
                let flickrPhotos = json.valueForKeyPath(FLICKR_RESULTS_PHOTOS)as? [[String : AnyObject]]
                else { return}
            
            // преобразуем в массив структур фотографий Photo
            self.photos = flickrPhotos.flatMap(Photo.init)
            
            dispatch_async(dispatch_get_main_queue()){
                self.refreshControl?.endRefreshing()
            }
        }
        task.resume()
    }
}

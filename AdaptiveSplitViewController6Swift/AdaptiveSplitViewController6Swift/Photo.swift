//
//  Photo.swift
//  AdaptiveSplitViewController6Swift
//
//  Created by Tatiana Kornilova on 3/11/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {
    
    convenience init?(dictionary : [String : AnyObject], context: NSManagedObjectContext) {
        guard var title = dictionary[FLICKR_PHOTO_TITLE] as? String,
            var subtitle = (dictionary as AnyObject).valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as? String,
            let imageURL = FlickrFetcher.URLforPhoto(dictionary,format:FlickrPhotoFormatLarge)?.absoluteString,
            let unique = dictionary[FLICKR_PHOTO_ID] as? String,
            let photographer =  dictionary[FLICKR_PHOTO_OWNER] as? String
            else {return nil}
        
        // убираем пробелы с обоих концов
        title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        subtitle = subtitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // специальные требования формирования атрибутов Photo
        let titleNew =  title == "" ? subtitle: title
        
        guard let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
            else {return nil}
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.unique = unique
        self.title = titleNew == "" ? "Unknown": titleNew
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.whoTook = Photographer(name: photographer, context: context)
    }
}


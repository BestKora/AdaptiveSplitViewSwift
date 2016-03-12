//
//  DataModel.swift
//  AdaptiveSplitViewController4Swift
//
//  Created by Tatiana Kornilova on 2/29/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import Foundation

struct Photo {
    let title : String
    let subtitle: String
    let unique: String
    let imageURL: String
    let photographer: String
    
    
    init?(json:[String:AnyObject]){
        
        guard var title = json[FLICKR_PHOTO_TITLE] as? String,
            var subtitle = (json as AnyObject).valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as? String,
            let imageURL = FlickrFetcher.URLforPhoto(json,format:FlickrPhotoFormatLarge)?.absoluteString,
            let unique = json[FLICKR_PHOTO_ID] as? String,
            let photographer =  json[FLICKR_PHOTO_OWNER] as? String
            else {return nil}
        
        // специальные требования формирования атрибутов Photo
        // убираем пробелы с обоих концов
        title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        subtitle = subtitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
         // специальные требования формирования атрибутов Photo
        let titleNew = title == "" ? subtitle: title
        self.title = titleNew == "" ? "Unknown": titleNew
        self.subtitle = subtitle
        self.unique = unique
        self.imageURL = imageURL
        self.photographer = photographer

    }
    
}


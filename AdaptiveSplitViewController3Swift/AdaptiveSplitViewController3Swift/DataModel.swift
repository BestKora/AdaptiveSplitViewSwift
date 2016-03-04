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
        
        guard let title = json[FLICKR_PHOTO_TITLE] as? String,
            let subtitle = (json as AnyObject).valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as? String,
            let imageURL = FlickrFetcher.URLforPhoto(json,format:FlickrPhotoFormatLarge)?.absoluteString,
            let unique = json[FLICKR_PHOTO_ID] as? String,
            let photographer =  json[FLICKR_PHOTO_OWNER] as? String
            else {return nil}
        
        // специальные требования формирования атрибутов Photo
        let subtitleNew =  subtitle ?? ""
        let titleNew =  title ?? subtitleNew
        self.title = titleNew == "" ? "Unknown": titleNew
        self.subtitle = subtitleNew
        self.unique = unique ?? ""
        self.imageURL = imageURL ?? ""
        self.photographer = photographer ?? ""
    }
    
    init?(userDefaults:[String:String]){
        guard let title = userDefaults["title"],
            let subtitle = userDefaults["subtitle"],
            let unique = userDefaults["unique"],
            let imageURL = userDefaults["imageURL"],
            let photographer = userDefaults["photographer"]
            else {return nil}
        self.title = title
        self.subtitle = subtitle
        self.unique = unique
        self.imageURL = imageURL
        self.photographer = photographer
    }
    
    func toDictionary() -> [String : String]{
        var photoDictionary = [String : String]()
        photoDictionary["title"] = self.title
        photoDictionary["subtitle"] = self.subtitle
        photoDictionary["unique"] = self.unique
        photoDictionary["imageURL"] = self.imageURL
        photoDictionary["photographer"] = self.photographer
        return photoDictionary
    }
}

struct Photographer {
    let name : String
    let photos :[Photo]
    
    init?(name: String,allPhotos:[Photo]){
        guard name != "" else {return nil}
        self.name = name
        self.photos = allPhotos.filter({$0.photographer == name })
    }
}
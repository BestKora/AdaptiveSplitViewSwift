//
//  ResentsDefault.swift
//  AdaptiveSplitViewController3Swift
//
//  Created by Tatiana Kornilova on 2/25/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import Foundation

final class ResentsDefault {
    
    var addedPhoto = Photo?() {
        didSet {
            guard let photo = addedPhoto else {return}
            resentsPhotos = addPhoto(resentsPhotos, photo: photo)
        }
    }
    
    var resentsPhotos: [[String : String]] {
        get {return defaults.objectForKey(Constants.DefaultsKey) as? [[String : String]] ?? []}
        set {defaults.setObject(newValue, forKey: Constants.DefaultsKey) }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private struct Constants {
        static let DefaultsKey = "Recents Viewed Photos"
        static let ResentsPhotoAmount = 20
    }

    private func addPhoto(let photos:[[String:String]], photo:Photo) -> [[String:String]]{
        var array = photos
        
        var photoDictionary = [String : String]()
        photoDictionary["title"] = photo.title
        photoDictionary["subtitle"] = photo.subtitle
        photoDictionary["unique"] = photo.unique
        photoDictionary["imageURL"] = photo.imageURL
        photoDictionary["photographer"] = photo.photographer
        
        if array.count >= Constants.ResentsPhotoAmount{
            array.removeLast()
        }
        if let index = array.indexOf({$0["unique"] == photoDictionary["unique"]}){
            array.removeRange(index..<index+1)
        }
        array.insert(photoDictionary, atIndex: 0)
        return array
    }
}



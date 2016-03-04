//
//  PhotosSavedNSUserDefaults.swift
//  AdaptiveSplitViewController3Swift
//
//  Created by Tatiana Kornilova on 2/27/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class PhotosSavedNSUserDefaults: FlickrPhotosTVC {
    private let resents = ResentsDefault()
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            resents.addedPhoto = photos[indexPath.row]
        }
    }
}

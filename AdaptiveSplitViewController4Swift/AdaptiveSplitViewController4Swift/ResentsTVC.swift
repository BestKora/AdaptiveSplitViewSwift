//
//  ResentsTVC.swift
//  AdaptiveSplitViewController3Swift
//
//  Created by Tatiana Kornilova on 2/25/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ResentsTVC: FlickrPhotosTVC {
    
    // если вы разместите код в viewDidLoad, то он будет вызван
    // только один раз при запуске приложения
    
    private let resents = ResentsDefault()
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.photos = resents.resentsPhotos.flatMap(Photo.init)
        
        }
}

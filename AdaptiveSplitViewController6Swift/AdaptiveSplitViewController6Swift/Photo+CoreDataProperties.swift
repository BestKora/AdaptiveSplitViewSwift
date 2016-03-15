//
//  Photo+CoreDataProperties.swift
//  AdaptiveSplitViewController6Swift
//
//  Created by Tatiana Kornilova on 3/11/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//


import Foundation
import CoreData

extension Photo {
    @NSManaged var imageURL: String
    @NSManaged var subtitle: String
    @NSManaged var title: String
    @NSManaged var unique: String
    @NSManaged var whoTook: Photographer?
  }

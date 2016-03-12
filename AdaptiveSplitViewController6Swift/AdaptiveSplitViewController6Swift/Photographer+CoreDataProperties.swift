//
//  Photographer+CoreDataProperties.swift
//  AdaptiveSplitViewController6Swift
//
//  Created by Tatiana Kornilova on 3/11/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//


import Foundation
import CoreData

extension Photographer {
    
    @NSManaged var name: String
    @NSManaged var photos: NSSet
}

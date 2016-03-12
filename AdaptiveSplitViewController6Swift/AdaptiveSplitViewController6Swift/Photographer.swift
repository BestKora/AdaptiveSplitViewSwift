//
//  Photographer.swift
//  AdaptiveSplitViewController6Swift
//
//  Created by Tatiana Kornilova on 3/11/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//


import Foundation
import CoreData

class Photographer: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func photographer(name: String, context: NSManagedObjectContext) -> Photographer? {
        var photographer: Photographer?
        
        if !name.isEmpty {
            guard let entity = NSEntityDescription.entityForName("Photographer", inManagedObjectContext: context)
                else {return nil}
            photographer = Photographer(entity: entity, insertIntoManagedObjectContext: context)
            photographer?.name = name
        }
        return photographer
    }
}

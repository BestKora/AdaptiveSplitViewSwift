/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import CoreData

class CoreDataStack: NSObject {
  static let moduleName = "FlickrModel"

  func saveMainContext() {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        fatalError("Error saving main managed object context! \(error)")
      }
    }
  }

  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()

  lazy var applicationDocumentsDirectory: NSURL = {
    return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

    let persistentStoreURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
    print (persistentStoreURL)

    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
        configuration: nil,
        URL: persistentStoreURL,
        options: [NSMigratePersistentStoresAutomaticallyOption: true,
          NSInferMappingModelAutomaticallyOption: false])
    } catch {
      fatalError("Persistent store error! \(error)")
    }
    return coordinator
  }()

  lazy var managedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    managedObjectContext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
  }()

}

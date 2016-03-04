//
//  AppDelegate.swift
//  AdaptiveSplitViewController2Swift
//
//  Created by Tatiana Kornilova on 2/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            if let splitViewController = self.window?.rootViewController as? UISplitViewController,
                navigationController = splitViewController.viewControllers.last as? UINavigationController {
                    navigationController.topViewController?.navigationItem.leftBarButtonItem
                                                                  = splitViewController.displayModeButtonItem()
                    navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
                    splitViewController.delegate = self
                    
                    splitViewController.preferredDisplayMode = .AllVisible
                    
                    //  splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                    //  splitViewController.maximumPrimaryColumnWidth = 512
            }
            
            self.window?.makeKeyAndVisible()
            return true
    }

    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController:UIViewController,
        ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
            
            guard let secondaryAsNav = secondaryViewController as? UINavigationController,
                let topAsDetail = secondaryAsNav.topViewController as? ImageViewController where
                topAsDetail.imageURL == nil else {return false}
            
            // Возврат true сигнализирует, что Detail должен быть отброшен
            return true
    }
    
    func splitViewController(splitViewController: UISplitViewController,
        separateSecondaryViewControllerFromPrimaryViewController
        primaryViewController: UIViewController) -> UIViewController? {
            
            guard let masterAsNav = primaryViewController as? UINavigationController,
                  let photosView = masterAsNav.topViewController as? FlickrPhotosTVC
            else { return nil }
            
             //-------- Detail----
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailAsNav =
                      storyboard.instantiateViewControllerWithIdentifier("detailNavigation")
                                    as? UINavigationController,
                  let controller = detailAsNav.visibleViewController as? ImageViewController
            else { return nil }
            
             // Выделяем первую строку
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            photosView.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
            
            // Обеспечиваем появление обратной кнопки
            controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            //--------Настройка Модели на первое photo ----
            if let photo = photosView.photos.first {
                controller.imageURL = NSURL(string: photo.imageURL)
                controller.title = photo.title
            }
            return detailAsNav
    }

}



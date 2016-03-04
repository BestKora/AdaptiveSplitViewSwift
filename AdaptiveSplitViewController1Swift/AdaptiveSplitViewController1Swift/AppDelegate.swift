//
//  AppDelegate.swift
//  AdaptiveSplitViewController1Swift
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
    
}



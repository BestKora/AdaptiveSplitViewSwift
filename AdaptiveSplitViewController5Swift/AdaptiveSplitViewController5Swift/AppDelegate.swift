//
//  AppDelegate.swift
//  AdaptiveSplitViewController5Swift
//
//  Created by Tatiana Kornilova on 3/3/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate  {

    var window: UIWindow?
    private let resents = ResentsDefault()

    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            if let splitViewController = self.window?.rootViewController as? UISplitViewController,
                navigationController = splitViewController.viewControllers.last as? UINavigationController {
                    navigationController.topViewController?.navigationItem.leftBarButtonItem
                        = splitViewController.displayModeButtonItem()
                    navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
                    splitViewController.delegate = self
                    
                    // splitViewController.preferredDisplayMode = .AllVisible
                    
                    // splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                    // splitViewController.maximumPrimaryColumnWidth = 512
                    
            }
            
            self.window?.makeKeyAndVisible()
            return true
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController:UIViewController,
        ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
            
            guard let secondaryAsNav = secondaryViewController as? UINavigationController,
                let topAsDetail = secondaryAsNav.topViewController as? ImageViewController
                where topAsDetail.imageURL == nil
                else {return false}
            
            // Возврат true сигнализирует, что Detail должен быть отброшен
            return true
    }
    
    func splitViewController(splitViewController: UISplitViewController,
        separateSecondaryViewControllerFromPrimaryViewController
        primaryViewController: UIViewController) -> UIViewController? {
            
            var urlString = ""
            guard let  masterVC = primaryViewController as? UITabBarController,
                let  primaryNav = masterVC.selectedViewController as? UINavigationController
                else { return nil }
            
            //---Если ImageView Controller как top в  NavigationController для Master,
            //---то убираем из стэка NavigationController, предварительно получив imageURL
            if let  ivc = primaryNav.topViewController as? ImageViewController,
                let url = ivc.imageURL {
                    urlString = url.absoluteString
                    
                    primaryNav.popViewControllerAnimated(false)
            }
            
            //-- Работаем со списком фотографий
            guard  let masterView =  primaryNav.topViewController as? FlickrPhotosTVC
                else { return nil }
            
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let photos = masterView.photos
            
            //-- Находим строку в списке фотографий по imageURL
            if let row = photos.indexOf({$0.imageURL == urlString}) {
                indexPath = NSIndexPath(forRow: row, inSection: 0)
            }
            
            //------ Получаем Detail со storyboard-----------------------
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailAsNav =
                storyboard.instantiateViewControllerWithIdentifier("detailNavigation")
                    as? UINavigationController,
                let controller = detailAsNav.visibleViewController as? ImageViewController
                else { return nil }
            
            // Выделяем нужную строку и photo
            masterView.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
            let photo = photos[indexPath.row]
            resents.addedPhoto = photos[indexPath.row]
            
            // Обеспечиваем появление обратной кнопки и настройку Модели
            controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.imageURL = NSURL(string: photo.imageURL)
            controller.title = photo.title
            
            return detailAsNav
    }
    
    
    func splitViewController(splitViewController: UISplitViewController,
        showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
            
            //--------Если ImageView Controller и режим collapsed,
            // то ImageViewController помещаем в стэк NavigationController для  Master----
            
            guard splitViewController.traitCollection.horizontalSizeClass == .Compact
                else { return  false}
            
            guard let  masterVC = splitViewController.viewControllers[0] as? UITabBarController,
                let  masterNav = masterVC.selectedViewController as? UINavigationController,
                let  detailNav = vc as? UINavigationController,
                let  ivc = detailNav.topViewController as? ImageViewController
                else {return  false}
            
            ivc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            ivc.navigationItem.leftItemsSupplementBackButton = true
            
            masterNav.showViewController(ivc, sender: sender)
            
            return  true
    }
    
}





//
//  PhotosCDTVC.swift
//  Photomania
//  Hook up fetchedResultsController to any Photo Fetch Request
//  Use "Photo Cell" as your table view cell's reuse object
//
//

import UIKit



class PhotosCDTVC: CoreDataTableViewController {

    private struct Storyboard {
        static let CellReuseIdentifier = "photoCell"
        static let SegueIdentifierPhoto = "Show Photo"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let cell = self.tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier),
              let photo = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Photo
            else {return UITableViewCell(style: .Subtitle, reuseIdentifier: Storyboard.CellReuseIdentifier)}
		
		cell.textLabel?.text = photo.title
        cell.detailTextLabel?.text = photo.subtitle == "" ? photo.unique: photo.subtitle
		
		return cell
	}
	
	// MARK: - Navigation
	
    func prepareViewController(viewController : UIViewController,
                               forSegue segue : String?,
                      fromIndexPath indexPath : NSIndexPath) {
        
        guard let photo = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Photo
                         else { return }
        var ivc = viewController
                        
        if let vc = viewController as? UINavigationController {
            ivc = vc.visibleViewController!
        }
        guard let ivcm = ivc as? ImageViewController  else { return }
                        
            ivcm.imageURL = NSURL(string: photo.imageURL)
            ivcm.title = photo.title
            ivcm.navigationItem.leftBarButtonItem =
                                         self.splitViewController?.displayModeButtonItem()
            ivcm.navigationItem.leftItemsSupplementBackButton = true
    }
    

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		var indexPath : NSIndexPath? = nil
		if let cell = sender as? UITableViewCell {
			indexPath = self.tableView.indexPathForCell(cell)
		}
		self.prepareViewController(segue.destinationViewController,
                                         forSegue: segue.identifier,
                                    fromIndexPath: indexPath!)
	}
	
}

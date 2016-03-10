//
//  URLViewController.swift
//  Photomania
//
//

import UIKit

class URLViewController: UIViewController {
	
	var url : NSURL? {
		didSet {
			self.updateUI()
		}
	}

	@IBOutlet weak var urlTextView: UITextView!
	 
    override func viewDidLoad() {
        super.viewDidLoad()
		self.updateUI()
    }

	func updateUI() {
		if let textView = self.urlTextView {
			if let url = self.url {
				textView.text = url.absoluteString
			}
		}
	}
    
     override var preferredContentSize: CGSize {
        get {
            if urlTextView != nil && presentingViewController != nil {
              var presentVC = presentingViewController!
                if let presentingVC = presentingViewController as? UISplitViewController
                                            where presentingVC.viewControllers.count == 2,
                   let detailNav = presentingVC.viewControllers[1] as? UINavigationController,
                   let detailVC = detailNav.topViewController as? ImageViewController
                {
                    presentVC = detailVC
                }
                
                return urlTextView.sizeThatFits(presentVC.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
}

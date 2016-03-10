//
//  URLViewController.swift
//  Photomania
//
//

import UIKit

class URLViewController: UIViewController,
UIPopoverPresentationControllerDelegate {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .Popover
        popoverPresentationController?.delegate = self
    }
    
    override var preferredContentSize: CGSize {
        get {
            if urlTextView != nil && presentingViewController != nil {
                return urlTextView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController,
        traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.None
    }
}

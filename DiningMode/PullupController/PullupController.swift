
//
//  PullupContainerViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import ObjectiveC

private var pullupControllerAssociationKey: UInt8 = 0

extension UIViewController {
    var pullupController: PullupController! {
        get {
            return objc_getAssociatedObject(self, &pullupControllerAssociationKey) as? PullupController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pullupControllerAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

class PullupController: UIViewController {

    // MARK: - Properties
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint!
    private var contentViewTopConstraint: NSLayoutConstraint!
    private var contentViewBottomConstraint: NSLayoutConstraint!

//    open weak var delegate: PullupControllerDelegate?
    public var bottomAnchorConstantForPullupBar: CGFloat = 0 {
        didSet {
            self.contentViewBottomConstraint.constant = self.bottomAnchorConstantForPullupBar
        }
    }
    
    public var toolbarViewController: UIViewController? {
        didSet {
            self.removeViewController(viewController: oldValue)
            self.addToolbarViewController(viewController: toolbarViewController!)
        }
    }
    
    public var pullupViewController: UIViewController? {
        didSet {
            self.removeViewController(viewController: oldValue)
            self.addPullupViewController(viewController: pullupViewController!)
        }
    }
    
    // MARK: - View States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the content view used for the pullup
        self.contentView = UIView(frame: view.frame)
        self.contentView.backgroundColor = UIColor.darkGray
        self.contentView.clipsToBounds = true
        self.view.addSubview(self.contentView)
        
        // setup contentView contraints
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.contentViewBottomConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.bottomAnchorConstantForPullupBar)
        self.contentViewBottomConstraint.isActive = true
        
        // We need to create a height constraint that we can use to modify the height of the pullup view. This is lower priority so that it can snap to the top of the view when we need to (letting go).
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 0)
        self.contentViewHeightConstraint.identifier = "contentViewHeightConstraint"
        self.contentViewHeightConstraint.priority = 750
        self.contentViewHeightConstraint.isActive = true
        
        self.contentViewTopConstraint = self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.contentViewTopConstraint.identifier = "contentViewTopConstraint"
        
        // we use a gesture to drag the pullup
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.toolbarDragGesture))
        self.contentView.addGestureRecognizer(panGestureRecognizer)
        
        // load the view controllers from the storyboard if there are any
        // TODO: Figure out a better way for this that is less error prone and can support not using a storyboard...
        
//        let segueTemplates = self.value(forKey: "storyboardSegueTemplates") as! NSArray
//        let segueId = segueTemplates.firstObject.value(forKey: "identifier")
        
        performSegue(withIdentifier: "idToolbarSegue", sender: self)
        performSegue(withIdentifier: "idPullupSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Manage ViewVontrollers
    
    private func removeViewController(viewController : UIViewController?) {
        if let oldVC = viewController {
            // notify and remove old viewcontroller from container
            oldVC.willMove(toParentViewController: nil)
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParentViewController()
        }
    }
    
    private func addToolbarViewController(viewController : UIViewController?) {
        if let toolbarVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(toolbarVC)
            self.contentView.addSubview(toolbarVC.view)
            toolbarVC.didMove(toParentViewController: self)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapToolBarGesture))
            toolbarVC.view.addGestureRecognizer(tapGestureRecognizer)
            
            // create contraints to make the toolbar snap the bottom of the layout
            toolbarVC.view.translatesAutoresizingMaskIntoConstraints = false
            toolbarVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            toolbarVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            toolbarVC.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            toolbarVC.view.heightAnchor.constraint(equalToConstant: toolbarVC.view.frame.height).isActive = true
            
            // Update the contentView to fit the height of this toolbar
            self.contentViewHeightConstraint.constant = toolbarVC.view.frame.height
            self.contentViewTopConstraint.constant = -toolbarVC.view.frame.height
            
            // We want the pullup always on top
            view.bringSubview(toFront: self.contentView)
            
            self.updatePullupConstraints()
        }
    }
    
    private func addPullupViewController(viewController : UIViewController?) {
        if let pullupVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(pullupVC)
            self.contentView.addSubview(pullupVC.view)
            pullupVC.didMove(toParentViewController: self)
            
            // we need to provide access to this pullupController to child classes
            if let navController = pullupVC as? UINavigationController {
                for viewController in navController.viewControllers {
                    viewController.pullupController = self
                }
            } else {
                pullupVC.pullupController = self
            }
            
            self.updatePullupConstraints()
        }
    }
    
    private func updatePullupConstraints() {
        if let pullupVC = pullupViewController, let toolbarVC = toolbarViewController {
            
            pullupVC.view.translatesAutoresizingMaskIntoConstraints = false
            pullupVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            pullupVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            pullupVC.view.topAnchor.constraint(equalTo: toolbarVC.view.bottomAnchor).isActive = true
            pullupVC.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - Navigation
    
    public func dismissPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let toolbarVC = self.toolbarViewController {
            self.contentViewHeightConstraint.constant = toolbarVC.view.frame.height
        } else {
            self.contentViewHeightConstraint.constant = 0
        }
        
        self.contentViewTopConstraint.isActive = false
        
        if (flag) {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.contentViewTopConstraint.isActive = true
        
        if (flag) {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        } else {
             self.view.layoutIfNeeded()
        }
    }
    
    @objc private func tapToolBarGesture(gestureRecognizer: UITapGestureRecognizer) {
        // either open or close the view depending on its current state
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            if (self.contentViewHeightConstraint.constant > view.frame.height * 0.5) {
                self.dismissPullup(animated: true)
            } else {
                self.openPullup(animated: true)
            }
        }
    }
    
    @objc private func toolbarDragGesture(gestureRecognizer: UIPanGestureRecognizer) {
        // we offset the pullup based on our drag.
        let translation = gestureRecognizer.translation(in: view)
        self.contentViewHeightConstraint.constant -= translation.y
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        
        // provide snapping animations when the view is let go based on a threshold
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            if (self.contentViewHeightConstraint.constant > view.frame.height * 0.5) {
                self.openPullup(animated: true)
            } else {
                self.dismissPullup(animated: true)
            }
        }
    }
}

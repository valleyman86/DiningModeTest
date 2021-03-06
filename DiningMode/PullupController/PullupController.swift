
//
//  PullupContainerViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol PullupControllerProtocol : class {
    weak var pullupController: PullupController? { get set }
}


class PullupController: UIViewController {

    // MARK: - Properties
    
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint!
    private var contentViewTopConstraint: NSLayoutConstraint!

    public var toolbarViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addToolbarViewController(viewController: toolbarViewController!)
        }
    }
    
    public var pullupViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addPullupViewController(viewController: pullupViewController!)
        }
    }
    
    // MARK: - View States
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the content view used for the pullup
        contentView = UIView(frame: view.frame)
        contentView.backgroundColor = UIColor.darkGray
        contentView.clipsToBounds = true
        self.tabBarController?.view.addSubview(contentView)
//        self.view.addSubview(contentView)
        
        // setup contentView contraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: (self.tabBarController?.view.leadingAnchor)!).isActive = true
        contentView.trailingAnchor.constraint(equalTo: (self.tabBarController?.view.trailingAnchor)!).isActive = true
        contentView.bottomAnchor.constraint(equalTo: (self.tabBarController?.tabBar.topAnchor)!).isActive = true
        
//        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // We need to create a height constraint that we can use to modify the height of the pullup view. This is lower priority so that it can snap to the top of the view when we need to (letting go).
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint.priority = 750
        contentViewHeightConstraint.isActive = true
        
        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: (self.tabBarController?.view.topAnchor)!)
        
        // we use a gesture to drag the pullup
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(toolbarDragGesture))
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        // load the view controllers from the storyboard if there are any
        // TODO: Figure out a better way for this that is less error prone and can support not using a storyboard...
        
//        let segueTemplates = self.value(forKey: "storyboardSegueTemplates") as! NSArray
//        let segueId = segueTemplates.firstObject.value(forKey: "identifier")
        
        performSegue(withIdentifier: "idToolbarSegue", sender: self)
        performSegue(withIdentifier: "idPullupSegue", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewWillLayoutSubviews();
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
            contentView.addSubview(toolbarVC.view)
            toolbarVC.didMove(toParentViewController: self)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToolBarGesture))
            toolbarVC.view.addGestureRecognizer(tapGestureRecognizer)
            
            // create contraints to make the toolbar snap the bottom of the layout
            toolbarVC.view.translatesAutoresizingMaskIntoConstraints = false
            toolbarVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            toolbarVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            toolbarVC.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            toolbarVC.view.heightAnchor.constraint(equalToConstant: toolbarVC.view.frame.height).isActive = true
            
            // Update the contentView to fit the height of this toolbar
            contentViewHeightConstraint.constant = toolbarVC.view.frame.height
            contentViewTopConstraint.constant = -toolbarVC.view.frame.height
            
            // We want the pullup always on top
            view.bringSubview(toFront: contentView)
            
            updatePullupConstraints()
        }
    }
    
    private func addPullupViewController(viewController : UIViewController?) {
        if let pullupVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(pullupVC)
            contentView.addSubview(pullupVC.view)
            pullupVC.didMove(toParentViewController: self)
            
            // we need to provide access to this pullupController to child classes
            if let navController = pullupVC as? UINavigationController {
                for viewController in navController.viewControllers {
                    if let currentVC = viewController as? PullupControllerProtocol {
                        currentVC.pullupController = self;
                    }
                }
            } else {
                if let currentVC = pullupVC as? PullupControllerProtocol {
                    currentVC.pullupController = self;
                }
            }
            
            updatePullupConstraints()
        }
    }
    
    private func updatePullupConstraints() {
        if let pullupVC = pullupViewController, let toolbarVC = toolbarViewController {
            
            pullupVC.view.translatesAutoresizingMaskIntoConstraints = false
            pullupVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            pullupVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            pullupVC.view.topAnchor.constraint(equalTo: toolbarVC.view.bottomAnchor).isActive = true
            pullupVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - Navigation
    
    public func dismissPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let toolbarVC = self.toolbarViewController {
            self.contentViewHeightConstraint.constant = toolbarVC.view.frame.height
        } else {
            self.contentViewHeightConstraint.constant = 0;
        }
        
        contentViewTopConstraint.isActive = false
        
        if (flag) {
            UIView.animate(withDuration: 0.1) {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height
//                self.view.layoutIfNeeded()
                self.tabBarController?.view.layoutIfNeeded()

            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        contentViewTopConstraint.isActive = true
        
        if (flag) {
            UIView.animate(withDuration: 0.1) {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height + (self.tabBarController?.tabBar.frame.height)!
//                self.view.layoutIfNeeded()
                self.tabBarController?.view.layoutIfNeeded()
            }
        } else {
             self.view.layoutIfNeeded()
        }
    }
    
    @objc private func tapToolBarGesture(gestureRecognizer: UITapGestureRecognizer) {
        // either open or close the view depending on its current state
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            if (contentViewHeightConstraint.constant > view.frame.height * 0.5) {
                self.dismissPullup(animated: true)
            } else {
                self.openPullup(animated: true)
            }
        }
    }
    
    @objc private func toolbarDragGesture(gestureRecognizer: UIPanGestureRecognizer) {
        // we offset the pullup based on our drag.
        let translation = gestureRecognizer.translation(in: view)
        contentViewHeightConstraint.constant -= translation.y
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
        
        // provide snapping animations when the view is let go based on a threshold
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            if (contentViewHeightConstraint.constant > view.frame.height * 0.5) {
                self.openPullup(animated: true)
            } else {
                self.dismissPullup(animated: true)
            }
        }
    }
}

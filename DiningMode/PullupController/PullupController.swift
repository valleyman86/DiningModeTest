
//
//  PullupContainerViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupController: UIViewController {

    // MARK: - Properties
    
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint!

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
        contentView.isUserInteractionEnabled = true
        contentView.clipsToBounds = true
        self.tabBarController?.view.addSubview(contentView)
//        view.addSubview(contentView)
        
        // setup contentView contraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: (self.tabBarController?.view.leadingAnchor)!).isActive = true
        contentView.trailingAnchor.constraint(equalTo: (self.tabBarController?.view.trailingAnchor)!).isActive = true
        contentView.bottomAnchor.constraint(equalTo: (self.tabBarController?.tabBar.topAnchor)!).isActive = true
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint.isActive = true;

        // we use a gesture to drag the pullup
    
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(toolbarDragGesture))
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToolBarGesture))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
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
            
            // create contraints to make the toolbar snap the bottom of the layout
            toolbarVC.view.translatesAutoresizingMaskIntoConstraints = false
            toolbarVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            toolbarVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            toolbarVC.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            toolbarVC.view.heightAnchor.constraint(equalToConstant: toolbarVC.view.frame.height).isActive = true
            
            // Update the contentView to fit the height of this toolbar
            contentViewHeightConstraint.constant = toolbarVC.view.frame.height
            
            // We want the pullup always on top
            view.bringSubview(toFront: contentView)
            
            updatePullupConstraints()
        }
    }
    
    private func addPullupViewController(viewController : UIViewController?) {
        if let pullupVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(pullupVC)
//            pullupVC.view.frame = view.frame
            contentView.addSubview(pullupVC.view)
            pullupVC.didMove(toParentViewController: self)
            
            updatePullupConstraints()
        }
    }
    
    private func updatePullupConstraints() {
        if let pullupVC = pullupViewController, let toolbarVC = toolbarViewController {
                        
            pullupVC.view.translatesAutoresizingMaskIntoConstraints = false
            pullupVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            pullupVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            pullupVC.view.topAnchor.constraint(equalTo: toolbarVC.view.bottomAnchor).isActive = true
//            pullupVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            pullupVC.view.heightAnchor.constraint(equalToConstant: pullupVC.view.frame.height).isActive = true
        }
    }
    
    // MARK: - Navigation
    
    public func dismissPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let toolbarVC = toolbarViewController {
            contentViewHeightConstraint.constant = toolbarVC.view.frame.height
        } else {
            contentViewHeightConstraint.constant = 0;
        }
        
        if (flag) {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    public func openPullup(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let toolbarVC = toolbarViewController {
            contentViewHeightConstraint.constant = view.frame.height + toolbarVC.view.frame.height
        } else {
            contentViewHeightConstraint.constant = view.frame.height
        }
        
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

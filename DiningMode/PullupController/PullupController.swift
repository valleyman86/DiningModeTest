
//
//  PullupContainerViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupController: UIViewController {

    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint!

    public var toolbarViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addToolbarViewController(viewController: toolbarViewController!)
        }
    }
    
    public var mainViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addMainViewController(viewController: mainViewController!)
        }
    }
    
    public var secondViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the content view used for the popup
        contentView = UIView(frame: view.frame)
        contentView.backgroundColor = UIColor.darkGray
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        
        // setup contentView contraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint.isActive = true;

        // we use a gesture to drag the popup
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(toolbarDragGesture))
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        // load the view controllers from the storyboard if there are any
        // TODO: Figure out a better way for this that is less error prone and can support not using a storyboard...
        performSegue(withIdentifier: "idMainSegue", sender: self)
        performSegue(withIdentifier: "idToolbarSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewWillLayoutSubviews();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeViewController(viewController : UIViewController?) {
        if let oldVC = viewController {
            // notify and remove old viewcontroller from container
            oldVC.willMove(toParentViewController: nil)
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParentViewController()
        }
    }
    
    private func addMainViewController(viewController : UIViewController?) {
        if let newVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(newVC)
            newVC.view.frame = view.bounds
            view.addSubview(newVC.view)
            newVC.didMove(toParentViewController: self)
        }
    }
    
    private func addToolbarViewController(viewController : UIViewController?) {
        if let newVC = viewController {
            // notify and add new viewcontroller to container
            addChildViewController(newVC)
            contentView.addSubview(newVC.view)
            newVC.didMove(toParentViewController: self)
            
            // create contraints to make the toolbar snap the bottom of the layout
            newVC.view.translatesAutoresizingMaskIntoConstraints = false
            newVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            newVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            newVC.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            newVC.view.heightAnchor.constraint(equalToConstant: newVC.view.frame.height).isActive = true
            
            // Update the contentView to fit the height of this toolbar
            contentViewHeightConstraint.constant = newVC.view.frame.height
            
            // We want the popup always on top
            view.bringSubview(toFront: contentView)
        }
    }
    
    
    @objc private func toolbarDragGesture(gestureRecognizer: UIPanGestureRecognizer) {
        // we offset the popup based on our drag.
        let translation = gestureRecognizer.translation(in: view)
        contentViewHeightConstraint.constant -= translation.y
        gestureRecognizer.setTranslation(CGPoint.zero, in: view)
//        NSLog("translation: %f", translation.y)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

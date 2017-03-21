
//
//  PullupContainerViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupController: UIViewController {

    var toolbarViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addToolbarViewController(viewController: toolbarViewController!)
        }
    }
    
    var mainViewController: UIViewController? {
        didSet {
            removeViewController(viewController: oldValue)
            addMainViewController(viewController: mainViewController!)
        }
    }
    
    var secondViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "idMainSegue", sender: self);
        self.performSegue(withIdentifier: "idToolbarSegue", sender: self);
        self.viewWillLayoutSubviews();
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
//            newVC.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
            view.addSubview(newVC.view)
            newVC.didMove(toParentViewController: self)
        }
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

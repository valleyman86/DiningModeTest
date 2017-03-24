//
//  testViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/24/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class testViewController: UINavigationController, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
        // Do any additional setup after loading the view.
        
        var navBarFrame = self.navigationBar.frame
        navBarFrame.size.height = 64
        self.navigationBar.frame = navBarFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.top
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

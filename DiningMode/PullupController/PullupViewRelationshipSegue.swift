//
//  PullupViewRelationshipSegue.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/21/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupViewRelationshipSegue: UIStoryboardSegue {

    override func perform() {
        let sourceVC = self.source as! PullupController
        sourceVC.pullupViewController = self.destination
    }
    
}

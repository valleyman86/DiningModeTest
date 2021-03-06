//
//  PullupToolbarViewRelationshipSegue.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/20/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupToolbarViewRelationshipSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceVC = self.source as! PullupController
        sourceVC.toolbarViewController = self.destination;
    }
    
}

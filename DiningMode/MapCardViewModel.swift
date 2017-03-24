//
//  MapCardViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import CoreLocation

class MapCardViewModel: NSObject {

    public var updatedCallback:(() -> Void)? {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var location:CLLocation! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var locationString:String! {
        get {
            return String(format: "%@ %@ %@ %@", self.street, self.city, self.state, self.zip)
        }
    }
    
    public var street:String! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var city:String! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    
    public var state:String! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var zip:String! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
}

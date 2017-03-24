//
//  RestaurantCardViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class RestaurantCardViewModel: NSObject {
    public var updatedCallback:(() -> Void)? {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }

    public var restaurantName:String! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var partySize:Int! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var partySizeString:String! {
        get {
            return String(self.partySize) + " people"
        }
    }
    
    public var reservationDate:Date! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var reservationDateString:String! {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "EEE, MMM dd"
            
            return dateFormatter.string(from: Date())
        }
    }
    
    public var reservationTimeString:String! {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.none
            
            return dateFormatter.string(from: Date())
        }
    }
    
    public var restaurantImage:UIImage! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public func getRestaurantImage(imageURL:String) -> Void {
        URLSession.shared.dataTask(with:URL(string:imageURL)!) { (data, response, error) in
            DispatchQueue.main.async() { () -> Void in
                self.restaurantImage = UIImage(data: data!)
            }
            }.resume()
    }
}

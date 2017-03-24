//
//  PullupBarViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/24/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class PullupBarViewModel: NSObject {

    private var reservation:Reservation!
    
    public var restaurantName:String!
    
    public func update(completion:() -> Void) -> Void {
        let url = Bundle.main.url(forResource: "PartialReservation", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        if let partialReservation = ReservationAssembler().createReservation(json) {
            self.reservation = partialReservation
            
            self.restaurantName = self.reservation.restaurant.name
            
            completion()
        }
    }
    
}

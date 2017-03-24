//
//  ReservationViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class ReservationViewModel: NSObject {
    public var reservation:Reservation!;
    
    public func update(completion:() -> Void) -> Void {
        let url = Bundle.main.url(forResource: "FullReservation", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        self.reservation = ReservationAssembler().createReservation(json)
        
        completion()
    }
}

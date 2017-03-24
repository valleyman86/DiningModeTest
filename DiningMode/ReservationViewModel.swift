//
//  ReservationViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import CoreLocation

class ReservationViewModel: NSObject {
    private var reservation:Reservation!
    
    public var restaurantName:String!
    public var restaurantProfileImageURI:String!
    public var partySize:Int!
    public var reservationDate:Date!
    
    public var restaurantStreet:String!
    public var restaurantCity:String!
    public var restaurantState:String!
    public var restaurantZip:String!
    public var restaurantLocation:CLLocation!
    
    public var restaurantDishes:Array<Dish>!
    
    public func update(completion:() -> Void) -> Void {
        let url = Bundle.main.url(forResource: "FullReservation", withExtension:"json")
        let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        if let newReservation = ReservationAssembler().createReservation(json) {
            self.reservation = newReservation
            
            self.restaurantName = self.reservation.restaurant.name
            self.restaurantProfileImageURI = self.reservation.restaurant.profilePhoto?.photoSizes.first?.uri
            self.partySize = self.reservation.partySize
            self.reservationDate = self.reservation.localDate
            
            self.restaurantStreet = self.reservation.restaurant.street
            self.restaurantCity = self.reservation.restaurant.city
            self.restaurantState = self.reservation.restaurant.state
            self.restaurantZip = self.reservation.restaurant.zip
            self.restaurantLocation = self.reservation.restaurant.location
            
            self.restaurantDishes = self.reservation.restaurant.dishes
            
            completion()
        }
    }
}

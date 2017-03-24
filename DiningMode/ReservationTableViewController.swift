//
//  ReservationTableViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

enum ReservationCards:Int {
    case restaurant = 0
    case map
    case dishes
}

class ReservationTableViewController: UITableViewController {
    private var viewModel: ReservationViewModel!
    private var cards: Set<ReservationCards> = Set()
    private var restaurantCardViewController: RestaurantCardViewController!
    private var mapCardViewController: MapCardViewController!
    private var dishesCardViewController: DishesCardViewController!

    @IBOutlet weak var dishesTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.viewModel = ReservationViewModel()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        let backgroundImageView = UIImageView(image: UIImage(named: "background.png"))
        self.tableView.backgroundView = backgroundImageView
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadData() -> Void {
        self.viewModel.update() {
        
            self.loadRestaurantCard()
            self.loadMapCard()
            self.loadPopularDishesCard()
            
            self.tableView.reloadData()
        };
    }
    
    private func loadRestaurantCard() -> Void {
        // Setup the restaurant info card by passing the relevant reservation data to it
        // TODO: Remove the access of the model and put relevant data in the viewModel for this view (currently violates MVVM)
        if (self.restaurantCardViewController != nil) {
            let restaurantCardVM = RestaurantCardViewModel()
            restaurantCardVM.restaurantName = self.viewModel.reservation.restaurant.name
            restaurantCardVM.getRestaurantImage(imageURL: (self.viewModel.reservation.restaurant.profilePhoto?.photoSizes.first?.uri)!)
            restaurantCardVM.partySize = self.viewModel.reservation.partySize
            restaurantCardVM.reservationDate = self.viewModel.reservation.localDate
            
            restaurantCardViewController.viewModel = restaurantCardVM
            
            cards.insert(ReservationCards.restaurant)
        }
    }
    
    private func loadMapCard() -> Void {
        // Setup the map card by passing the relevant reservation data to it
        // TODO: Remove the access of the model and put relevant data in the viewModel for this view (currently violates MVVM)
        if (self.mapCardViewController != nil) {
            let mapCardVM = MapCardViewModel()
            mapCardVM.street = self.viewModel.reservation.restaurant.street
            mapCardVM.city = self.viewModel.reservation.restaurant.city
            mapCardVM.state = self.viewModel.reservation.restaurant.state
            mapCardVM.zip = self.viewModel.reservation.restaurant.zip
            mapCardVM.location = self.viewModel.reservation.restaurant.location
            
            self.mapCardViewController.viewModel = mapCardVM
            
            cards.insert(ReservationCards.map)
        }
    }
    
    private func loadPopularDishesCard() -> Void {
        // Setup the popular dishes card by passing the relevant reservation data to it
        // TODO: Remove the access of the model and put relevant data in the viewModel for this view (currently violates MVVM)
        if (self.dishesCardViewController != nil && self.viewModel.reservation.restaurant.dishes.count > 0) {
            let dishesCardVM = DishesCardViewModel()
            dishesCardVM.dishes = self.viewModel.reservation.restaurant.dishes
            
            self.dishesCardViewController.layoutUpdatedCallback = {
                self.dishesTableViewCell.layoutIfNeeded()
            }
            self.dishesCardViewController.viewModel = dishesCardVM
            
            cards.insert(ReservationCards.dishes)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (cards.contains(ReservationCards(rawValue: indexPath.row)!)) {
            return UITableViewAutomaticDimension
        } else {
            return 0
        }
    }

    // MARK: - Segues

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "idRestaurantCardEmbedSegue") {
            self.restaurantCardViewController = segue.destination as! RestaurantCardViewController
        } else if (segue.identifier == "idMapCardEmbedSegue") {
            self.mapCardViewController = segue.destination as! MapCardViewController
        } else if (segue.identifier == "idDishesCardEmbedSegue") {
            self.dishesCardViewController = segue.destination as! DishesCardViewController
        }
    }
}

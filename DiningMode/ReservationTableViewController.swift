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

class ReservationTableViewController: UITableViewController, PullupControllerProtocol {
    internal var pullupController: PullupController?
    
    private var viewModel: ReservationViewModel!
    private var cards: NSMutableOrderedSet = NSMutableOrderedSet()
    private var restaurantCardViewController: RestaurantCardViewController!
    private var mapCardViewController: MapCardViewController!
    private var dishesCardViewController: DishesCardViewController!

    private let navBarHeight:CGFloat = 64
    
    @IBOutlet weak var dishesTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.viewModel = ReservationViewModel()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        
        let backgroundImageView = UIImageView(image: UIImage(named: "background.png"))
        self.tableView.backgroundView = backgroundImageView
        
        self.tableView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationBar.frame.size.height = navBarHeight
    }
    
    private func loadData() -> Void {
        self.viewModel.update() {
        
            self.loadRestaurantCard()
            self.loadMapCard()
            self.loadPopularDishesCard()
            
            self.tableView.reloadData()
        };
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        if let pullup = self.pullupController {
            pullup.dismissPullup(animated: true)
        }
    }
    
    private func loadRestaurantCard() -> Void {
        // Setup the restaurant info card by passing the relevant reservation data to it
        if (self.restaurantCardViewController != nil) {
            let restaurantCardVM = RestaurantCardViewModel()
            restaurantCardVM.restaurantName = self.viewModel.restaurantName
            restaurantCardVM.getRestaurantImage(imageURL: self.viewModel.restaurantProfileImageURI)
            restaurantCardVM.partySize = self.viewModel.partySize
            restaurantCardVM.reservationDate = self.viewModel.reservationDate
            
            restaurantCardViewController.viewModel = restaurantCardVM
            
            cards.add(ReservationCards.restaurant)
        }
    }
    
    private func loadMapCard() -> Void {
        // Setup the map card by passing the relevant reservation data to it
        if (self.mapCardViewController != nil) {
            let mapCardVM = MapCardViewModel()
            mapCardVM.street = self.viewModel.restaurantStreet
            mapCardVM.city = self.viewModel.restaurantCity
            mapCardVM.state = self.viewModel.restaurantState
            mapCardVM.zip = self.viewModel.restaurantZip
            mapCardVM.location = self.viewModel.restaurantLocation
            
            self.mapCardViewController.viewModel = mapCardVM
            
            cards.add(ReservationCards.map)
        }
    }
    
    private func loadPopularDishesCard() -> Void {
        // Setup the popular dishes card by passing the relevant reservation data to it
        if (self.dishesCardViewController != nil && self.viewModel.restaurantDishes.count > 0) {
            let dishesCardVM = DishesCardViewModel()
            dishesCardVM.dishes = self.viewModel.restaurantDishes
            
            self.dishesCardViewController.layoutUpdatedCallback = {
                self.dishesTableViewCell.layoutIfNeeded()
            }
            self.dishesCardViewController.viewModel = dishesCardVM
            
            cards.add(ReservationCards.dishes)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // we load the cards in the order we prefer and if a card doesnt exist we can skip it
        let card = cards[indexPath.row] as! ReservationCards
        let newIndexPath = IndexPath(row: card.rawValue, section: 0)
        return super.tableView(tableView, cellForRowAt: newIndexPath)
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

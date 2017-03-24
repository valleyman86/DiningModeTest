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
}

class ReservationTableViewController: UITableViewController {
    private var viewModel: ReservationViewModel!
    private var cards: Set<ReservationCards> = Set()
    private var restaurantCardViewController: RestaurantCardViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.viewModel = ReservationViewModel();
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.loadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadData() -> Void {
        self.viewModel.update() {
        
            loadRestaurantCard();
        
            self.tableView.reloadData();
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case ReservationCards.map.rawValue:
                return UITableViewAutomaticDimension;
            default:
                return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "idRestaurantCardEmbedSegue") {
            self.restaurantCardViewController = segue.destination as! RestaurantCardViewController
        }
    }
 

}

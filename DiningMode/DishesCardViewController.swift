//
//  DishesCardViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishesCardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    public var viewModel: DishesCardViewModel! {
        didSet {
            self.viewModel.updatedCallback = { [unowned self] in
                self.tableView.reloadData();
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        self.tableView.rowHeight = 85
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func viewWillLayoutSubviews() {
//        
//        tableViewHeightConstraint.constant = self.tableView.contentSize.height
//        super.updateViewConstraints()
////        
////        self.parent?.view.setNeedsLayout()
////        self.parent?.view.layoutIfNeeded()
////        self.parent?.updateViewConstraints()
////        self.parent?.view.updateConstraintsIfNeeded()
//        
////        self.view.setNeedsLayout()
////        self.view.layoutIfNeeded()
////        self.updateViewConstraints()
////        self.view.updateConstraintsIfNeeded()
//    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.viewModel.dishes.count, 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idDishCell", for: indexPath) as! DishesCardTableViewCell
        
        // populate cell with content
        let dish = self.viewModel.dishes[indexPath.row]
        cell.nameLabel.text = dish.name
        cell.descriptionLabel.attributedText = self.viewModel.dishDescription(dish: dish)
        self.viewModel.getDishImage(imageURL: (dish.photos.first?.photoSizes.first?.uri)!) { (image: UIImage) in
            cell.dishImageView.image = image
        }
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

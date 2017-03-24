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
                if (self.layoutUpdatedCallback != nil) {
                    self.layoutUpdatedCallback!()
                }
            }
        }
    }
    
    // this property is used to update the layouts to fit after the content changes.
    public var layoutUpdatedCallback:(() -> Void)?
    
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
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableViewHeightConstraint.constant = self.tableView.contentSize.height
        self.updateViewConstraints()
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.viewModel.dishes.count, 3)
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
}

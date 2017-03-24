//
//  DishesCardTableViewCell.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/24/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishesCardTableViewCell: UITableViewCell {

    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

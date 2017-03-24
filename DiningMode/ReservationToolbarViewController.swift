//
//  PullupBarViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/24/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class ReservationToolbarViewController: UIViewController {

    private var viewModel: ReservationToolbarViewModel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = ReservationToolbarViewModel()
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func loadData() -> Void {
        self.viewModel.update() {
            nameLabel.text = self.viewModel.restaurantName
        };
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

//
//  MapCardViewController.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit
import MapKit

class MapCardViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    public var viewModel: MapCardViewModel! {
        didSet {
            self.viewModel.updatedCallback = { [unowned self] in
                self.addressLabel.text = self.viewModel.locationString
                // setup the map
                let viewRegion = MKCoordinateRegionMakeWithDistance(self.viewModel.location.coordinate, 800, 800)
                let adjustedRegion = self.mapView.regionThatFits(viewRegion)
                self.mapView.setRegion(adjustedRegion, animated: false)
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.viewModel.location.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

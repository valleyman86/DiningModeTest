//
//  ViewController.swift
//  DiningMode
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

import AFNetworking

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// just to make sure everything links fine
		AFHTTPSessionManager(baseURL: nil).get("", parameters: nil, progress: nil, success: nil, failure: nil)

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		// Dispose of any resources that can be recreated.
	}


}


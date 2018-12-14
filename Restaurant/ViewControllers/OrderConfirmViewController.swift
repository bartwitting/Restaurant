//
//  OrderConfirmViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController {
    /// Defining outlets and variables
    @IBOutlet weak var timeLabel: UILabel!
    var minutes: Int!
    
    /// Building the screen and fill the label
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."
    }
}

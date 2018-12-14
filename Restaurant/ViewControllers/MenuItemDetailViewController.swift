//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    /// Defining the variables, this one is from the last VC
    var menuItem: MenuItem!
    
    /// Defining the outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    /// Action to order this menu item
    @IBAction func orderButTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.orderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.orderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    /// Building the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        orderButton.layer.cornerRadius = 5.0
        updateUI()
    }
    
    /// Function to fill in the labels
    func updateUI() {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}

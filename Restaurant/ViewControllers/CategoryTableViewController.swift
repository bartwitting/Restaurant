//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class CategoryTableViewController : UITableViewController {
    /// Defining variables
    var categories = [String]()
    
    /// Building the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    /// Function to get data from server and send it to update function
    func getData() {
        MenuController.shared.fetchCategories {
            (categories) in if let categories = categories {
                self.updateUI(with: categories)
            }
        }
    }
    
    /// Function to get data into variables
    func updateUI(with categories : [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    /// Action to get back to the category list
    @IBAction func unwindToCat(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToCatVC" {
            getData()
        }
    }
    
    /// Function to set amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    /// Function to make the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellId", for: indexPath)
        configure(cell : cell, forItemAt : indexPath)
        return cell
    }
    
    /// Function to fill in the cell
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    
    /// Action to send the chosen category to the next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let menutableVC = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menutableVC.category = categories[index]
        }
    }
}

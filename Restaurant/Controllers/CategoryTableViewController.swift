//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class CategoryTableViewController : UITableViewController {
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchCategories {
            (categories) in if let categories = categories {
                self.updateUI(with: categories)
            }
        }
    }
    
    func updateUI(with categories : [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToCat(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToCat" {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellId", for: indexPath)
        configure(cell : cell, forItemAt : indexPath)
        return cell
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let menutableVC = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menutableVC.category = categories[index]
        }
    }
}

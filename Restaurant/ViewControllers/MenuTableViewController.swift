//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    /// Defining variables, like one from the last VC
    var menuItems = [MenuItem]()
    var category: String!
    
    /// Building the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        MenuController.shared.fetchMenuItems(categoryName: category) {
            (menuItems) in
            if let menuItems = menuItems {
                self.updateUI(with: menuItems)
            }
        }
    }
    
    /// Function to put the data in the variable
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    /// Function to set the cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /// Function to set the amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    /// Function to make the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellId", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    /// Function to fill the cell
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.imageView?.image = image
                //        set the image size, partially copied from: https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
                //
                let itemSize = CGSize.init(width: 100, height: 100)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                cell.imageView?.image!.draw(in: imageRect)
                cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                UIGraphicsEndImageContext();
            }
        }
    }
    
    /// Action to send the menuitem to the next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuitemdetailVC = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuitemdetailVC.menuItem = menuItems[index]
        }
    }
}

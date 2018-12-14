//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    ///Defining the variables
    var order = Order() 
    var orderMinutes = 0
    
    /// Building the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    /// Action to get back to this order list
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    /// Action to submit the order and get the price and preptime
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        if orderTotal == 0 {
            let empty = UIAlertController(title: "Empty Order", message: "You tried to order nothing", preferredStyle: .alert)
            empty.addAction(UIAlertAction(title: "Order something", style: .default) { action in self.performSegue(withIdentifier: "unwindToCatVC", sender: self)
            })
            empty.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(empty, animated: true, completion: nil)
        }
        else {
            print("Order total:", orderTotal)
            let formattedOrder = String(format: "$%.2f", orderTotal)
            let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
                self.uploadOrder()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// Function to push the order to the server
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIds) { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmSegue", sender: nil)
                }
            }
        }
    }
    
    /// Action to send details to the next VC, the preptime or the orderdetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmSegue" {
            let orderconfirmVC = segue.destination as! OrderConfirmViewController
            orderconfirmVC.minutes = orderMinutes
        }
        else if segue.identifier == "orderDetail" {
            let menuitemdetailVC = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuitemdetailVC.menuItem = MenuController.shared.order.menuItems[index]
        }
    }
    
    
    /// Function to make a cell editible
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    /// Function to define the action when deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
    
    /// Function to define the cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /// Function to set amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    /// Function to make the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellId", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    /// Function to fill the cell
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
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
}

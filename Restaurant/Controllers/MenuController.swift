//
//  MenuController.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//
import UIKit

class MenuController {
    /// Defining the variables
    static let shared = MenuController()
    //let baseURL = URL(string: "http://localhost:8090/")!
    let baseURL = URL(string: "https://resto.mprog.nl/")!
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    /// Function to retrieve the category data from the server
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL) {
            (data, response, error) in if let data = data, let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    /// Function to retrieve the menu data from the server
    func fetchMenuItems(categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name:"category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) {
            (data, response, error) in let jsonDecoder = JSONDecoder()
            if let data = data, let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    /// Function to write the order data to the servers
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in let jsonDecoder = JSONDecoder()
            if let data = data, let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    /// Function to retrieve image data from the server
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
}

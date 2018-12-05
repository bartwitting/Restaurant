//
//  Order.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import Foundation

struct Order : Codable {
    var menuItems : [MenuItem]
    
    init(menuItems : [MenuItem] = []) {
        self.menuItems = menuItems
    }
}

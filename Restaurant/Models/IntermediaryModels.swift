//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Bart Witting on 05/12/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import Foundation

struct Categories : Codable {
    let categories : [String]
}

struct PreparationTime : Codable {
    let prepTime : Int
    
    enum CodingKeys : String, CodingKey {
        case prepTime = "preparation_time"
    }
}

//
//  Item.swift
//  Todoey
//
//  Created by Hayner Esteves on 24/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

// For the class to conform to encodable all its propertys must have standarts data types. (Int, String, Bool, Float, etc)
class Item: Codable {
    var checkStatus: Bool = false
    let title: String
    
    init(Description: String) {
        self.title = Description
    }
}

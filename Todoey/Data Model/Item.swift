//
//  Item.swift
//  Todoey
//
//  Created by Hayner Esteves on 24/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

class Item {
    var CheckStatus: Bool
    let Description: String
    
    init(CheckStatus: Bool, Description: String) {
        self.CheckStatus = CheckStatus
        self.Description = Description
    }
}

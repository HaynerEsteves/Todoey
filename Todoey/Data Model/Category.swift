//
//  Category.swift
//  Todoey
//
//  Created by Hayner Esteves on 21/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {//class has a 1 to many relationship with Item
    @objc dynamic var name: String = ""
    @objc dynamic var hexCategoryColor: String = ""
    var item = List<Item>()//creating the link (relationship in database) between the 2 classes. List is like an array (a container) from realm that points to the other class. This is the owning model object. Category owns Item
}

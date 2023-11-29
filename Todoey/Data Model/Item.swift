//
//  Item.swift
//  Todoey
//
//  Created by Hayner Esteves on 21/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {// this class has a 1 to 1 relationship with Category. Each item has 1 parent category
    @objc dynamic var checkStatus: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var hexItemColor: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")//This is how we connect the inverse relationship between entitys. (Category.self ~> type not object.) é fornecido o tipo da classe e a propriedade dela onde o link deve ser feito.
}

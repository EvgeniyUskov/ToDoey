//
//  Item.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 29/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects (fromType: Category.self, property: "items")
}

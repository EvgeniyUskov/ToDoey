 //
//  Category.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 29/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation
import RealmSwift
 
 class Category: Object {
    @objc dynamic var title: String = ""
    let items = List<Item>()
        
 }

//
//  Item.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 15/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import Foundation

class Item {
    var text: String = ""
    var checked: Bool = false
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
}

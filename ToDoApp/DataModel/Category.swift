//
//  Category.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 3/3/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}

//
//  Item.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 3/3/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //Define relacion uno a muchos con las categorias
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    //Property = nombre de la variable de "Item" que se utilizará
    //Category.self = objetos de category del tipo Category(self)
}

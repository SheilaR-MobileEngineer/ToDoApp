//
//  Item.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 2/3/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import Foundation

//Hacer la clase encodable y decodable con: CODABLE para que pueda ser encodable en json etc.
class Item: Codable{
    
    var title : String = ""
    var done : Bool = false
}

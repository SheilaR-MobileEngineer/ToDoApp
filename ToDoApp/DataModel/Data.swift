//
//  Data.swift
//  ToDoApp
//
//  Created by Sheila Rodríguez on 3/3/19.
//  Copyright © 2019 Sheila Rodríguez. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    
    //dynamic sustituye al default "static" para permitir monitoreo de cambios at runtime
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}

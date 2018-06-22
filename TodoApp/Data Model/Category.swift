//
//  Category.swift
//  TodoApp
//
//  Created by Gera Garza on 6/20/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import Foundation
import RealmSwift


//realm object, save data using realm
class Category: Object{
    
    //we can specify category, monitor for changes while app is
    //running(dynamic)
    @objc dynamic var name :String = ""
    
    //each category can have a number of items
    let items = List<Item>()

}

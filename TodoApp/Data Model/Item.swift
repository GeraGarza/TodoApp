//
//  Item.swift
//  TodoApp
//
//  Created by Gera Garza on 6/20/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import Foundation
import RealmSwift

//also sublassing realm
class Item: Object{
    
    //three propties
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    //specify inverse relationship, links item to parent, type and name
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
 
    
}

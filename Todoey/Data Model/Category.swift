//
//  Category.swift
//  Todoey
//
//  Created by Peter Lawless on 11/1/18.
//  Copyright © 2018 Peter Lawless. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color: String?
    let items = List<Item>()
}

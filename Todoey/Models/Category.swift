//
//  Category.swift
//  Todoey
//
//  Created by Mateusz Ziobrowski on 15/06/2019.
//  Copyright © 2019 Mateusz Ziobrowski. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items: List<Item> = List<Item>()
}

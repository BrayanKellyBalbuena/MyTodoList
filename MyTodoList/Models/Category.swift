//
//  Category.swift
//  MyTodoList
//
//  Created by Brayan Kelly Balbuena on 1/18/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexcolor: String = ""
    var items = List<Item>()
}

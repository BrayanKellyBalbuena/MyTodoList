//
//  Item.swift
//  MyTodoList
//
//  Created by Brayan Kelly Balbuena on 1/18/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import Foundation
import RealmSwift
import os

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
   var category = LinkingObjects<Category>(fromType: Category.self, property: "items")
}

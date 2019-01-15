//
//  Item.swift
//  MyTodoList
//
//  Created by Brayan Kelly Balbuena on 1/6/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String
    var isDone: Bool
    
    init(title: String, isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
    }
}

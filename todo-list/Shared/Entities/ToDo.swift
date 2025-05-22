//
//  ToDo.swift
//  todo-list
//
//  Created by Мария Анисович on 20.05.2025.
//

import UIKit

struct ToDo {
    let id: UUID
    var title: String
    var description: String
    var creationDate: Date
    var isDone: Bool
}

extension ToDo {
    init(from item: ToDoItem) {
        self.id = item.id
        self.title = item.title
        self.description = item.desc
        self.creationDate = item.creationDate
        self.isDone = item.isDone
    }
}

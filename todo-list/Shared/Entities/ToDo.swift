//
//  ToDo.swift
//  todo-list
//
//  Created by Мария Анисович on 20.05.2025.
//

import UIKit

class ToDo {
    let id: UUID
    var title: String
    var description: String
    var creationDate: Date
    var isDone: Bool

    init(id: UUID, title: String, description: String, creationDate: Date, isDone: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.isDone = isDone
    }

    convenience init(from item: ToDoItem) {
        self.init(
            id: item.id,
            title: item.title,
            description: item.desc,
            creationDate: item.creationDate,
            isDone: item.isDone
        )
    }
}

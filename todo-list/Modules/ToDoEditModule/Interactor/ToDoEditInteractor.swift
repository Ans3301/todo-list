//
//  ToDoEditInteractor.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditInteractorProtocol {
    func getToDo() -> ToDo
    func saveToDo(toDo: ToDo)
}

final class ToDoEditInteractor: ToDoEditInteractorProtocol {
    private var toDo: ToDo
    private var storage: StorageProtocol

    init(toDo: ToDo, storage: StorageProtocol) {
        self.toDo = toDo
        self.storage = storage
    }

    func getToDo() -> ToDo {
        return toDo
    }

    func saveToDo(toDo: ToDo) {
        storage.saveToDo(toDo: toDo)
    }
}

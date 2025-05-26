//
//  ToDoEditInteractor.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol? { get set }
    var storage: StorageProtocol { get set }
    var toDo: ToDo? { get set }

    func saveToDo(toDo: ToDo)
}

class ToDoEditInteractor: ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol?
    var storage: StorageProtocol
    var toDo: ToDo?

    init(storage: StorageProtocol) {
        self.storage = storage
    }

    func saveToDo(toDo: ToDo) {
        if self.toDo == nil {
            storage.addToDo(toDo: toDo)
        } else {
            storage.updateToDo(toDo: toDo)
        }
    }
}

//
//  ToDoEditInteractor.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol? {get set}
    
    func getToDo()
    func saveToDo(toDo: ToDo)
}

class ToDoEditInteractor: ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol?
    private var toDo: ToDo
    private var storage: StorageProtocol

    init(toDo: ToDo, storage: StorageProtocol) {
        self.toDo = toDo
        self.storage = storage
    }

    func getToDo() {
        presenter?.didGetToDo(toDo: toDo)
    }

    func saveToDo(toDo: ToDo) {
        storage.saveToDo(toDo: toDo)
    }
}

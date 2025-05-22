//
//  Untitled.swift
//  todo-list
//
//  Created by Мария Анисович on 21.05.2025.
//

import UIKit

protocol ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol? { get set }

    func fetchToDoList()
    func updateToDoStatus(toDo: ToDo)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol?

    private var toDoList: [ToDo] {
        return CoreDataManager.shared.fetchToDoList()
    }

    func fetchToDoList() {
        presenter?.didFetchToDoList(toDoList: toDoList)
    }

    func updateToDoStatus(toDo: ToDo) {
        var updatedToDo = toDo
        updatedToDo.isDone.toggle()
        CoreDataManager.shared.updateToDo(toDo: updatedToDo)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
}

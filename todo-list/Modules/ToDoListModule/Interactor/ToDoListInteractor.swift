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
    func updateToDo(toDo: ToDo)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol?

    private var toDoList: [ToDo] = [
        ToDo(id: UUID(), title: "Buy milk", description: "Buy milk at the store near work", creationDate: Date(), isDone: false),
        ToDo(id: UUID(), title: "Walk dog", description: "Don't forget to take an umbrella", creationDate: Date(), isDone: false)
    ]

    func fetchToDoList() {
        presenter?.didFetchToDoList(toDoList: toDoList)
    }

    func updateToDo(toDo: ToDo) {
        if let index = toDoList.firstIndex(where: { $0.id == toDo.id }) {
            toDoList[index].isDone.toggle()
        }
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
}

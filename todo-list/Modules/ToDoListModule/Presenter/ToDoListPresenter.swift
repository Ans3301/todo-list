//
//  ToDoListPresenter.swift
//  todo-list
//
//  Created by Мария Анисович on 21.05.2025.
//

import UIKit

protocol ToDoListPresenterProtocol {
    var view: ToDoListViewProtocol? { get set }
    var interactor: ToDoListInteractorProtocol? { get set }
    var router: ToDoListRouterProtocol? { get set }

    func viewWillAppear()
    func updateToDoStatus(toDo: ToDo)

    func didFetchToDoList(toDoList: [ToDo])
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?

    func viewWillAppear() {
        interactor?.fetchToDoList()
    }

    func updateToDoStatus(toDo: ToDo) {
        interactor?.updateToDoStatus(toDo: toDo)
    }

    func didFetchToDoList(toDoList: [ToDo]) {
        view?.showToDoList(toDoList: toDoList)
    }
}

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
    func showToDoEdit(toDo: ToDo)
    func updateToDoStatus(toDo: ToDo)
    func deleteToDo(toDo: ToDo)

    func didFetchToDoList(toDoList: [ToDo])
    func didUpdateToDoStatus(toDo: ToDo)
}

final class ToDoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?

    func viewWillAppear() {
        interactor?.fetchToDoList()
    }

    func showToDoEdit(toDo: ToDo) {
        guard let view = view else { return }
        router?.presentToDoEditScreen(from: view, toDo: toDo)
    }

    func updateToDoStatus(toDo: ToDo) {
        interactor?.updateToDoStatus(toDo: toDo)
    }

    func deleteToDo(toDo: ToDo) {
        interactor?.deleteToDo(toDo: toDo)
    }

    func didFetchToDoList(toDoList: [ToDo]) {
        view?.showToDoList(toDoList: toDoList)
    }

    func didUpdateToDoStatus(toDo: ToDo) {
        view?.showUpdatedToDo(updatedToDo: toDo)
    }
}

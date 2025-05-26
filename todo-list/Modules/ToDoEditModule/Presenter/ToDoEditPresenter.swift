//
//  ToDoEditPresenter.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditPresenterProtocol {
    var view: ToDoEditViewProtocol? { get set }
    var interactor: ToDoEditInteractorProtocol? { get set }
    var router: ToDoEditRouter? { get set }

    func viewWillAppear()

    func didGetToDo(toDo: ToDo)
    func didTapBackButton(toDo: ToDo)
}

class ToDoEditPresenter: ToDoEditPresenterProtocol {
    weak var view: ToDoEditViewProtocol?
    var interactor: ToDoEditInteractorProtocol?
    var router: ToDoEditRouter?

    func viewWillAppear() {
        interactor?.getToDo()
    }

    func didGetToDo(toDo: ToDo) {
        view?.showToDo(toDo: toDo)
    }

    func didTapBackButton(toDo: ToDo) {
        interactor?.saveToDo(toDo: toDo)

        if let view = view {
            router?.navigateBackToToDoListScreen(from: view)
        }
    }
}

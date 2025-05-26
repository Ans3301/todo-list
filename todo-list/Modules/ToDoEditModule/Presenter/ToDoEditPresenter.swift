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

    func didTapBackButton(toDo: ToDo)
}

final class ToDoEditPresenter: ToDoEditPresenterProtocol {
    weak var view: ToDoEditViewProtocol?
    var interactor: ToDoEditInteractorProtocol?
    var router: ToDoEditRouter?

    func viewWillAppear() {
        if let interactor = interactor {
            view?.showToDo(toDo: interactor.getToDo())
        }
    }

    func didTapBackButton(toDo: ToDo) {
        interactor?.saveToDo(toDo: toDo)

        if let view = view {
            router?.navigateBackToToDoListScreen(from: view)
        }
    }
}

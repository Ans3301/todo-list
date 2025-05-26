//
//  ToDoEditRouter.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditRouterProtocol {
    static func createModule(toDo: ToDo) -> UIViewController

    func navigateBackToToDoListScreen(from view: ToDoEditViewProtocol)
}

final class ToDoEditRouter: ToDoEditRouterProtocol {
    static func createModule(toDo: ToDo) -> UIViewController {
        let view = ToDoEditViewController()
        let presenter = ToDoEditPresenter()
        let interactor = ToDoEditInteractor(toDo: toDo, storage: CoreDataStorage.shared)
        let router = ToDoEditRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        return view
    }

    func navigateBackToToDoListScreen(from view: ToDoEditViewProtocol) {
        guard let viewController = view as? UIViewController else {
            fatalError("Invalid view protocol type")
        }
        viewController.navigationController?.popViewController(animated: false)
    }
}

//
//  ToDoListRouter.swift
//  todo-list
//
//  Created by Мария Анисович on 22.05.2025.
//

import UIKit

protocol ToDoListRouterProtocol {
    static func createModule() -> UIViewController
}

class ToDoListRouter: ToDoListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = ToDoListViewController()
        let presenter = ToDoListPresenter()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

//
//  ToDoListRouter.swift
//  todo-list
//
//  Created by Мария Анисович on 22.05.2025.
//

import UIKit

protocol ToDoListRouterProtocol {
    static func createModule() -> UIViewController
    
    func presentToDoEditScreen(from view: ToDoListViewProtocol, toDo: ToDo?)
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
    
    func presentToDoEditScreen(from view: ToDoListViewProtocol, toDo: ToDo?) {
         let toDoEditViewController = ToDoEditViewController()
         
         guard let viewController = view as? UIViewController else {
             fatalError("Invalid View Protocol type")
         }
         
        viewController.navigationController?.pushViewController(toDoEditViewController, animated: false)
     }
}

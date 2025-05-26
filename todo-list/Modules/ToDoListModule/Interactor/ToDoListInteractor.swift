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
    func deleteToDo(toDo: ToDo)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol?

    private let apiService = APIService()

    private var toDoList: [ToDo] {
        return CoreDataManager.shared.fetchToDoList()
    }

    func fetchToDoList() {
        if !UserDefaults.standard.bool(forKey: "isAppAlreadyLaunchedOnce") {
            Task {
                do {
                    let toDoList = try await apiService.loadToDoList()
                    await self.importToDoList(toDoList: toDoList)
                    UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
                } catch {}
            }
        } else {
            presenter?.didFetchToDoList(toDoList: toDoList)
        }
    }

    @MainActor
    func importToDoList(toDoList: [ToDo]) {
        for toDo in toDoList {
            CoreDataManager.shared.addToDo(toDo: toDo)
        }
        presenter?.didFetchToDoList(toDoList: self.toDoList)
    }

    func updateToDoStatus(toDo: ToDo) {
        toDo.isDone.toggle()
        CoreDataManager.shared.updateToDo(toDo: toDo)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
    
    func deleteToDo(toDo: ToDo) {
        CoreDataManager.shared.deleteToDo(id: toDo.id)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
}

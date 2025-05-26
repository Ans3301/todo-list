//
//  Untitled.swift
//  todo-list
//
//  Created by Мария Анисович on 21.05.2025.
//

import UIKit

protocol ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol? { get set }
    var apiService: APIServiceProtocol { get set }
    var storage: StorageProtocol { get set }
    var storageForKey: StorageForKeyProtocol { get set }

    func fetchToDoList()
    func updateToDoStatus(toDo: ToDo)
    func deleteToDo(toDo: ToDo)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol?
    var apiService: APIServiceProtocol
    var storage: StorageProtocol
    var storageForKey: StorageForKeyProtocol

    init(apiService: APIServiceProtocol, storage: StorageProtocol, storageForKey: StorageForKeyProtocol) {
        self.apiService = apiService
        self.storage = storage
        self.storageForKey = storageForKey
    }

    private var toDoList: [ToDo] {
        return storage.fetchToDoList()
    }

    func fetchToDoList() {
        if !storageForKey.bool(forKey: "isAppAlreadyLaunchedOnce") {
            Task {
                do {
                    let toDoList = try await apiService.loadToDoList()
                    await self.importToDoList(toDoList: toDoList)
                    storageForKey.set(true, forKey: "isAppAlreadyLaunchedOnce")
                } catch {}
            }
        } else {
            presenter?.didFetchToDoList(toDoList: toDoList)
        }
    }

    @MainActor
    func importToDoList(toDoList: [ToDo]) {
        for toDo in toDoList {
            storage.addToDo(toDo: toDo)
        }
        presenter?.didFetchToDoList(toDoList: self.toDoList)
    }

    func updateToDoStatus(toDo: ToDo) {
        toDo.isDone.toggle()
        storage.updateToDo(toDo: toDo)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }

    func deleteToDo(toDo: ToDo) {
        storage.deleteToDo(id: toDo.id)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
}

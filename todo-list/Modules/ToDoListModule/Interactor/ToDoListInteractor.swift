//
//  Untitled.swift
//  todo-list
//
//  Created by Мария Анисович on 21.05.2025.
//

import os
import UIKit

protocol ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol? { get set }

    func fetchToDoList()
    func updateToDoStatus(toDo: ToDo)
    func deleteToDo(toDo: ToDo)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    var presenter: ToDoListPresenterProtocol?
    private var apiService: APIServiceProtocol
    private var storage: StorageProtocol
    private var storageForKey: StorageForKeyProtocol

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
                } catch {
                    Logger.mainLogger.error("Failed to load ToDoList: \(error.localizedDescription, privacy: .public)")
                }
            }
        } else {
            presenter?.didFetchToDoList(toDoList: toDoList)
        }
    }

    @MainActor
    private func importToDoList(toDoList: [ToDo]) {
        for toDo in toDoList {
            storage.saveToDo(toDo: toDo)
        }
        presenter?.didFetchToDoList(toDoList: self.toDoList)
    }

    func updateToDoStatus(toDo: ToDo) {
        toDo.isDone.toggle()
        storage.saveToDo(toDo: toDo)
        presenter?.didUpdateToDoStatus(toDo: toDo)
    }

    func deleteToDo(toDo: ToDo) {
        storage.deleteToDo(id: toDo.id)
        presenter?.didFetchToDoList(toDoList: toDoList)
    }
}

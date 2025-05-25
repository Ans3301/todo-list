//
//  ToDoEditInteractor.swift
//  todo-list
//
//  Created by Мария Анисович on 25.05.2025.
//

import UIKit

protocol ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol? { get set }
    var toDo: ToDo? { get set }
    
    func saveToDo(toDo: ToDo)
}

class ToDoEditInteractor: ToDoEditInteractorProtocol {
    var presenter: ToDoEditPresenterProtocol?
    var toDo: ToDo?
    
    func saveToDo(toDo: ToDo) {
        if self.toDo == nil {
            CoreDataManager.shared.addToDo(toDo: toDo)
        } else {
            CoreDataManager.shared.updateToDo(toDo: toDo)
        }
    }
}

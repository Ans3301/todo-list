//
//  CoreDataManager.swift
//  todo-list
//
//  Created by Мария Анисович on 22.05.2025.
//

import CoreData

protocol StorageProtocol {
    func addToDo(toDo: ToDo)
    func updateToDo(toDo: ToDo)
    func fetchToDoList() -> [ToDo]
    func deleteToDo(id: UUID)
}

final class CoreDataStorage: StorageProtocol {
    static let shared = CoreDataStorage()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func addToDo(toDo: ToDo) {
        let toDoItem = ToDoItem(context: context)
        toDoItem.id = toDo.id
        toDoItem.title = toDo.title
        toDoItem.desc = toDo.description
        toDoItem.creationDate = toDo.creationDate
        toDoItem.isDone = toDo.isDone

        saveContext()
    }

    func updateToDo(toDo: ToDo) {
        let context = CoreDataStorage.shared.context
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", toDo.id as CVarArg)
        request.fetchLimit = 1

        do {
            if let item = try context.fetch(request).first {
                item.title = toDo.title
                item.desc = toDo.description
                item.creationDate = toDo.creationDate
                item.isDone = toDo.isDone

                try context.save()
            }
        } catch {
            print("Failed to toggle isDone: \(error)")
        }
    }

    func fetchToDoList() -> [ToDo] {
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()

        do {
            let toDoItems = try context.fetch(fetchRequest)
            var toDos: [ToDo] = []
            for toDoItem in toDoItems {
                toDos.append(ToDo(from: toDoItem))
            }
            return toDos
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func deleteToDo(id: UUID) {
        let context = CoreDataStorage.shared.context
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let item = try context.fetch(request).first {
                context.delete(item)
                try context.save()
            }
        } catch {
            print("Error deleting ToDoItem: \(error)")
        }
    }
}

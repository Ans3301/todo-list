//
//  APIService.swift
//  todo-list
//
//  Created by Мария Анисович on 23.05.2025.
//

import UIKit

struct ToDoAPIResponse: Codable {
    let todos: [ToDoAPIModel]
}

struct ToDoAPIModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

final class APIService {
    func loadToDoList() async throws ->  [ToDo] {
        let urlString = "https://dummyjson.com/todos"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(ToDoAPIResponse.self, from: data)

        var toDoList: [ToDo] = []
        for toDo in decoded.todos {
            let newToDo = ToDo(id: UUID(), title: toDo.todo, description: toDo.todo, creationDate: Date(), isDone: toDo.completed)
            toDoList.append(newToDo)
        }
        
        return toDoList
    }
}

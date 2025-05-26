//
//  ToDoEditInteractorTests.swift
//  todo-list
//
//  Created by Мария Анисович on 26.05.2025.
//

@testable import todo_list
import XCTest

final class ToDoEditInteractorTests: XCTestCase {
    class MockStorage: StorageProtocol {
        var savedToDo: ToDo?

        func fetchToDoList() -> [ToDo] {
            return []
        }

        func saveToDo(toDo: ToDo) {
            savedToDo = toDo
        }

        func deleteToDo(id: UUID) {}
    }

    func testGetToDo() {
        let expectedToDo = ToDo(id: UUID(), title: "Test", description: "Desc", creationDate: Date(), isDone: false)
        let storage = MockStorage()
        let interactor = ToDoEditInteractor(toDo: expectedToDo, storage: storage)

        let result = interactor.getToDo()

        XCTAssertEqual(result.id, expectedToDo.id)
        XCTAssertEqual(result.title, expectedToDo.title)
        XCTAssertEqual(result.description, expectedToDo.description)
        XCTAssertEqual(result.creationDate, expectedToDo.creationDate)
        XCTAssertEqual(result.isDone, expectedToDo.isDone)
    }

    func testSaveToDo() {
        let originalToDo = ToDo(id: UUID(), title: "Original", description: "Desc", creationDate: Date(), isDone: false)
        let updatedToDo = ToDo(id: originalToDo.id, title: "Updated", description: "Updated Desc", creationDate: originalToDo.creationDate, isDone: true)

        let storage = MockStorage()
        let interactor = ToDoEditInteractor(toDo: originalToDo, storage: storage)

        interactor.saveToDo(toDo: updatedToDo)

        XCTAssertEqual(storage.savedToDo?.id, updatedToDo.id)
        XCTAssertEqual(storage.savedToDo?.title, "Updated")
        XCTAssertEqual(storage.savedToDo?.description, "Updated Desc")
        XCTAssertEqual(storage.savedToDo?.isDone, true)
    }
}

//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Мария Анисович on 26.05.2025.
//

@testable import todo_list
import XCTest

final class ToDoListInteractorTests: XCTestCase {
    class MockPresenter: ToDoListPresenterProtocol {
        var view: ToDoListViewProtocol?
        var interactor: ToDoListInteractorProtocol?
        var router: ToDoListRouterProtocol?

        var didFetchToDoListCalled = false
        var fetchedToDoList: [ToDo] = []

        var didUpdateToDoStatusCalled = false
        var updatedToDo: ToDo?

        private var expectation: XCTestExpectation?

        init(expectation: XCTestExpectation? = nil) {
            self.expectation = expectation
        }

        func didFetchToDoList(toDoList: [ToDo]) {
            didFetchToDoListCalled = true
            fetchedToDoList = toDoList
            expectation?.fulfill()
        }

        func didUpdateToDoStatus(toDo: ToDo) {
            didUpdateToDoStatusCalled = true
            updatedToDo = toDo
        }

        func viewWillAppear() {}
        func showToDoEdit(toDo: ToDo) {}
        func updateToDoStatus(toDo: ToDo) {}
        func deleteToDo(toDo: ToDo) {}
    }

    class MockStorage: StorageProtocol {
        var storedToDos: [ToDo] = []

        func fetchToDoList() -> [ToDo] {
            return storedToDos
        }

        func saveToDo(toDo: ToDo) {
            if let index = storedToDos.firstIndex(where: { $0.id == toDo.id }) {
                storedToDos[index] = toDo
            } else {
                storedToDos.append(toDo)
            }
        }

        func deleteToDo(id: UUID) {
            storedToDos.removeAll { $0.id == id }
        }
    }

    class MockAPIService: APIServiceProtocol {
        var toDosToReturn: [ToDo] = []
        var shouldThrowError = false

        func loadToDoList() async throws -> [ToDo] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: 1)
            }
            return toDosToReturn
        }
    }

    class MockStorageForKey: StorageForKeyProtocol {
        var storage: [String: Bool] = [:]

        func bool(forKey key: String) -> Bool {
            return storage[key] ?? false
        }

        func set(_ value: Bool, forKey key: String) {
            storage[key] = value
        }
    }

    func testFetchToDoListFirstLaunch() {
        let expectation = XCTestExpectation(description: "Wait for fetchToDoList to complete")

        let presenter = MockPresenter(expectation: expectation)
        let storage = MockStorage()
        let apiService = MockAPIService()
        let keyStorage = MockStorageForKey()

        apiService.toDosToReturn = [ToDo(id: UUID(), title: "Test", description: "", creationDate: Date(), isDone: false)]
        let interactor = ToDoListInteractor(apiService: apiService, storage: storage, storageForKey: keyStorage)
        interactor.presenter = presenter

        interactor.fetchToDoList()

        wait(for: [expectation])

        XCTAssertTrue(presenter.didFetchToDoListCalled)
        XCTAssertEqual(presenter.fetchedToDoList.count, 1)
        XCTAssertTrue(keyStorage.bool(forKey: "isAppAlreadyLaunchedOnce"))
    }

    func testFetchToDoListNotFirstLaunch() {
        let presenter = MockPresenter()
        let storage = MockStorage()
        let apiService = MockAPIService()
        let keyStorage = MockStorageForKey()
        keyStorage.set(true, forKey: "isAppAlreadyLaunchedOnce")

        storage.storedToDos = [ToDo(id: UUID(), title: "Test", description: "", creationDate: Date(), isDone: false)]

        let interactor = ToDoListInteractor(apiService: apiService, storage: storage, storageForKey: keyStorage)
        interactor.presenter = presenter

        interactor.fetchToDoList()

        XCTAssertTrue(presenter.didFetchToDoListCalled)
        XCTAssertEqual(presenter.fetchedToDoList.count, 1)
        XCTAssertEqual(presenter.fetchedToDoList.first?.title, "Test")
    }

    func testUpdateToDoStatus() {
        let presenter = MockPresenter()
        let storage = MockStorage()
        let apiService = MockAPIService()
        let keyStorage = MockStorageForKey()

        let todo = ToDo(id: UUID(), title: "Test", description: "", creationDate: Date(), isDone: false)
        storage.storedToDos = [todo]

        let interactor = ToDoListInteractor(apiService: apiService, storage: storage, storageForKey: keyStorage)
        interactor.presenter = presenter

        interactor.updateToDoStatus(toDo: todo)

        XCTAssertTrue(presenter.didUpdateToDoStatusCalled)
        XCTAssertEqual(storage.storedToDos.first?.isDone, true)
    }

    func testDeleteToDo() {
        let presenter = MockPresenter()
        let storage = MockStorage()
        let apiService = MockAPIService()
        let keyStorage = MockStorageForKey()

        let todo = ToDo(id: UUID(), title: "Delete", description: "", creationDate: Date(), isDone: false)
        storage.storedToDos = [todo]

        let interactor = ToDoListInteractor(apiService: apiService, storage: storage, storageForKey: keyStorage)
        interactor.presenter = presenter

        interactor.deleteToDo(toDo: todo)

        XCTAssertTrue(presenter.didFetchToDoListCalled)
        XCTAssertTrue(storage.storedToDos.isEmpty)
    }
}

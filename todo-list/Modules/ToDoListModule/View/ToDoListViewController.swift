//
//  ViewController.swift
//  todo-list
//
//  Created by Мария Анисович on 20.05.2025.
//

import UIKit

protocol ToDoListViewProtocol: AnyObject {
    var presenter: ToDoListPresenterProtocol? { get set }
    
    func showToDoList(toDoList: [ToDo])
}

final class ToDoListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.separatorInset = .zero
        return tableView
    }()
        
    private var toDoList: [ToDo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var presenter: ToDoListPresenterProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "toDoTableViewCell")
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 172),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableViewCell") as? ToDoTableViewCell else {
            fatalError("Unable to dequeue ToDoTableViewCell")
        }
        cell.configure(toDo: toDoList[indexPath.row])
        cell.statusButtonTapped = { [weak self] in
            if let toDo = self?.toDoList[indexPath.row] {
                self?.presenter?.updateToDoStatus(toDo: toDo)
            }
        }
        return cell
    }
}

extension ToDoListViewController: ToDoListViewProtocol {
    func showToDoList(toDoList: [ToDo]) {
        self.toDoList = toDoList
    }
}

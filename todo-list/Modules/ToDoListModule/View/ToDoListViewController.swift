//
//  ViewController.swift
//  todo-list
//
//  Created by Мария Анисович on 20.05.2025.
//

import SwifterSwift
import UIKit

protocol ToDoListViewProtocol: AnyObject {
    var presenter: ToDoListPresenterProtocol? { get set }
    
    func showToDoList(toDoList: [ToDo])
    func showUpdatedToDo(updatedToDo: ToDo)
}

final class ToDoListViewController: UIViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .black
        searchBar.tintColor = .white
        searchBar.searchTextField.backgroundColor = UIColor(hexString: "#272729")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5),
            ]
        )
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.5)
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private lazy var footerView: FooterView = {
        let footerView = FooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = UIColor(hexString: "#272729")
        return footerView
    }()
        
    private var fullDoList: [ToDo] = []
    private var toDoList: [ToDo] = [] {
        didSet {
            tableView.reloadData()
            footerView.updateToDoCount(count: toDoList.count)
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
        
        title = "Задачи"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backButtonTitle = "Назад"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupSearchBar()
        setupTableView()
        setupFooterView()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func setupTableView() {
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "toDoTableViewCell")
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 202),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupFooterView() {
        footerView.onAddButtonTapped = { [weak self] in
            self?.presenter?.showToDoEdit(toDo: ToDo(id: UUID(), title: "", description: "", creationDate: Date(), isDone: false))
        }
        
        view.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 83),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            toDoList = fullDoList
        } else {
            toDoList = fullDoList.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableViewCell") as? ToDoTableViewCell else {
            fatalError("Unable to dequeue ToDoTableViewCell")
        }
        cell.configure(toDo: toDoList[indexPath.row])
        cell.onStatusButtonTapped = { [weak self] in
            if let toDo = self?.toDoList[indexPath.row] {
                self?.presenter?.updateToDoStatus(toDo: toDo)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = toDoList[indexPath.row]

        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.presenter?.showToDoEdit(toDo: todo)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.presenter?.deleteToDo(toDo: todo)
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView,
                   previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath)
        else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = UIColor(hexString: "#272729")

        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    }
}

extension ToDoListViewController: ToDoListViewProtocol {
    func showToDoList(toDoList: [ToDo]) {
        fullDoList = toDoList
        self.toDoList = toDoList
    }
    
    func showUpdatedToDo(updatedToDo: ToDo) {
        if let fullIndex = fullDoList.firstIndex(where: { $0.id == updatedToDo.id }) {
            fullDoList[fullIndex] = updatedToDo
        }

        if let index = toDoList.firstIndex(where: { $0.id == updatedToDo.id }) {
            toDoList[index] = updatedToDo
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

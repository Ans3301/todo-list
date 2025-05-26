//
//  ToDoEditViewController.swift
//  todo-list
//
//  Created by Мария Анисович on 23.05.2025.
//

import SwifterSwift
import UIKit

protocol ToDoEditViewProtocol: AnyObject {
    var presenter: ToDoEditPresenterProtocol? { get set }
    
    func showToDo(toDo: ToDo?)
}

final class ToDoEditViewController: UIViewController {
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название"
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()

    private lazy var creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание"
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var toDo: ToDo?
    
    var presenter: ToDoEditPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        title = " "
        navigationItem.largeTitleDisplayMode = .never
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupTitleTextView()
        setupTitlePlaceholderLabel()
        setupCreationDateLabel()
        setupDescriptionTextView()
        setupDescriptionPlaceholderLabel()
        
        presenter?.viewDidLoad()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent && !titleTextView.text.isEmpty && !descriptionTextView.text.isEmpty {
            guard let toDo = toDo else {
                let newToDo = ToDo(id: UUID(), title: titleTextView.text, description: descriptionTextView.text, creationDate: Date(), isDone: false)
                presenter?.didTapBackButton(toDo: newToDo)
                return
            }

            toDo.title = titleTextView.text
            toDo.description = descriptionTextView.text
            presenter?.didTapBackButton(toDo: toDo)
        }
    }
    
    private func setupTitleTextView() {
        view.addSubview(titleTextView)
        
        titleTextView.delegate = self
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 106),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTitlePlaceholderLabel() {
        view.addSubview(titlePlaceholderLabel)
        
        NSLayoutConstraint.activate([
            titlePlaceholderLabel.topAnchor.constraint(equalTo: titleTextView.topAnchor),
            titlePlaceholderLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor)
        ])
    }
    
    private func setupCreationDateLabel() {
        view.addSubview(creationDateLabel)
        
        NSLayoutConstraint.activate([
            creationDateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 16),
            creationDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
        
        descriptionTextView.delegate = self
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupDescriptionPlaceholderLabel() {
        view.addSubview(descriptionPlaceholderLabel)
        
        NSLayoutConstraint.activate([
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor)
        ])
    }
}

extension ToDoEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
}

extension ToDoEditViewController: ToDoEditViewProtocol {
    func showToDo(toDo: ToDo?) {
        self.toDo = toDo
        
        if let toDo = toDo {
            titleTextView.text = toDo.title
            creationDateLabel.text = formattedDate(date: toDo.creationDate)
            descriptionTextView.text = toDo.description
            
            titlePlaceholderLabel.isHidden = true
            descriptionPlaceholderLabel.isHidden = true
        } else {
            creationDateLabel.text = formattedDate(date: Date())
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

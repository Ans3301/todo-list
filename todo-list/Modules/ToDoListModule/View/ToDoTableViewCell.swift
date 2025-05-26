//
//  ToDoTableViewCell.swift
//  todo-list
//
//  Created by Мария Анисович on 20.05.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    private lazy var isDoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    
    var statusButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        selectionStyle = .none
        
        setupIsDoneButton()
        setupTitleLabel()
        setupDescriptionLabel()
        setupCreationDateLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIsDoneButton() {
        contentView.addSubview(isDoneButton)
        
        NSLayoutConstraint.activate([
            isDoneButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            isDoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            isDoneButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        isDoneButton.addTarget(self, action: #selector(isDoneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func isDoneButtonTapped() {
        statusButtonTapped?()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: isDoneButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: isDoneButton.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupCreationDateLabel() {
        contentView.addSubview(creationDateLabel)
        
        NSLayoutConstraint.activate([
            creationDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            creationDateLabel.leadingAnchor.constraint(equalTo: isDoneButton.trailingAnchor, constant: 8),
            creationDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    func configure(toDo: ToDo) {
        descriptionLabel.text = toDo.description
        creationDateLabel.text = formattedDate(date: toDo.creationDate)
        
        if toDo.isDone {
            isDoneButton.setImage(UIImage(named: "Icon"), for: .normal)
            
            let attributedText = NSMutableAttributedString(string: toDo.title)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedText.length))
            attributedText.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.white.withAlphaComponent(0.5), range: NSMakeRange(0, attributedText.length))
            
            titleLabel.attributedText = attributedText
            titleLabel.textColor = .white.withAlphaComponent(0.5)
            
            descriptionLabel.textColor = .white.withAlphaComponent(0.5)
            
        } else {
            isDoneButton.setImage(UIImage(named: "circle"), for: .normal)
            
            titleLabel.attributedText = .none
            titleLabel.text = toDo.title
            titleLabel.textColor = .white
            
            descriptionLabel.textColor = .white
        }
    }
}

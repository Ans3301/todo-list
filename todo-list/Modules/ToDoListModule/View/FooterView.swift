//
//  FooterView.swift
//  todo-list
//
//  Created by Мария Анисович on 23.05.2025.
//

import SwifterSwift
import UIKit

final class FooterView: UIView {
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 задач"
        label.textColor = .white
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(hexString: "#FED702")
        return button
    }()

    var onAddButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCountLabel()
        setupAddButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCountLabel() {
        addSubview(countLabel)

        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18)
        ])
    }
    
    private func setupAddButton() {
        addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 28),
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        onAddButtonTapped?()
    }

    func updateToDoCount(count: Int) {
        let word = getWordForm(count: count)
        countLabel.text = "\(count) \(word)"
    }

    private func getWordForm(count: Int) -> String {
        let lastTwoDigits = count % 100
        let lastDigit = count % 10

        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "задач"
        }

        switch lastDigit {
            case 1:
                return "задача"
            case 2, 3, 4:
                return "задачи"
            default:
                return "задач"
        }
    }
}

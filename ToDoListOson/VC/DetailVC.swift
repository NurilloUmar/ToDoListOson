//
//  DetailVC.swift
//  ToDoListOson
//
//  Created by hayot on 9/19/25.
//

import UIKit

class DetailVC: UIViewController {
    
    var item: ModelCoreDM?
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let titleLabel = UILabel()
    private let completedSwitch = UISwitch()
    private let completedLabel = UILabel()
    
    private let userCard = UIStackView()
    private let nameRow = InfoRow(icon: "person.circle.fill")
    private let usernameRow = InfoRow(icon: "at.circle.fill")
    private let emailRow = InfoRow(icon: "envelope.circle.fill")
    
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Onfinite", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        contentStack.addArrangedSubview(titleLabel)
        
        let completedStack = UIStackView(arrangedSubviews: [completedLabel, completedSwitch])
        completedStack.axis = .horizontal
        completedStack.spacing = 12
        completedStack.alignment = .center
        contentStack.addArrangedSubview(completedStack)
        
        userCard.axis = .vertical
        userCard.spacing = 8
        userCard.layer.cornerRadius = 12
        userCard.backgroundColor = UIColor.secondarySystemBackground
        userCard.isLayoutMarginsRelativeArrangement = true
        userCard.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        [nameRow, usernameRow, emailRow].forEach { row in
            userCard.addArrangedSubview(row)
        }
        
        contentStack.addArrangedSubview(userCard)
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureData() {
        guard let item = item else { return }
        titleLabel.text = item.title ?? "No Title"
        
        completedLabel.text = "Completed"
        completedSwitch.isOn = item.completed ?? false
        
        nameRow.setText(item.userName ?? "Unknown")
        usernameRow.setText(item.userName ?? "")
        emailRow.setText(item.email ?? "")
    }
}

class InfoRow: UIStackView {
    private let iconView = UIImageView()
    private let label = UILabel()
    
    init(icon: String) {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 8
        alignment = .center
        
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .systemGray
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        label.font = .systemFont(ofSize: 16)
        
        addArrangedSubview(iconView)
        addArrangedSubview(label)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}

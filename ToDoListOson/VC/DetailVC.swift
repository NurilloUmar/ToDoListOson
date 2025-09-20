//
//  DetailVC.swift
//  ToDoListOson
//
//  Created by hayot on 9/19/25.
//

import UIKit

class DetailVC: UIViewController {
    
    var item: ModelCoreDM?
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let completedLabel = UILabel()
    private let userNameLabel = UILabel()
    private let emailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureData()
    }
    
    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, completedLabel, userNameLabel, emailLabel].forEach {
            $0.numberOfLines = 0
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func configureData() {
        guard let item = item else { return }
        titleLabel.text = "📝 Title: \(item.title ?? ""))"
        completedLabel.text = item.completed ?? false ? "✅ Completed" : "❌ Not completed"
        userNameLabel.text = "👤 User: \(item.userName ?? ""))"
        emailLabel.text = "📧 Email: \(item.email ?? "")"
    }
}

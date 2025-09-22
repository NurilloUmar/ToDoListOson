import UIKit

final class HomeTVC: UITableViewCell {
    
    private let container = UIView()
    private let titleLbl = UILabel()
    private let userLbl  = UILabel()
    private let stack    = UIStackView()
    private let statusBar = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("Use programmatic init") }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.separator.cgColor
        
        statusBar.layer.cornerRadius = 3
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.numberOfLines = 2
        titleLbl.font = .preferredFont(forTextStyle: .headline)
        titleLbl.adjustsFontForContentSizeCategory = true
        titleLbl.textColor = .label
        
        userLbl.font = .preferredFont(forTextStyle: .subheadline)
        userLbl.textColor = .secondaryLabel
        userLbl.adjustsFontForContentSizeCategory = true
        
        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubview(titleLbl)
        stack.addArrangedSubview(userLbl)
    }
    
    private func setupLayout() {
        contentView.addSubview(container)
        container.addSubview(stack)
        container.addSubview(statusBar)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Status bar
            statusBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: container.topAnchor),
            statusBar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            statusBar.widthAnchor.constraint(equalToConstant: 6),
            
            // Stack
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: statusBar.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
    
    func setCell(item: ModelCoreDM) {
        userLbl.text = item.userName
        
        if item.completed == true {
            titleLbl.text = item.title
            statusBar.backgroundColor = .systemGreen
        } else {
            titleLbl.text = item.title
            statusBar.backgroundColor = .systemRed
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = nil
        userLbl.text  = nil
        statusBar.backgroundColor = .clear
    }
}

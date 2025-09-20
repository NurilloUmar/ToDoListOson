import UIKit

final class HomeTVC: UITableViewCell {

    private let titleLbl = UILabel()
    private let userLbl  = UILabel()
    private let stack    = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLbl.numberOfLines = 2
        titleLbl.font = .systemFont(ofSize: 16, weight: .semibold)

        userLbl.font = .systemFont(ofSize: 13)
        userLbl.textColor = .secondaryLabel

        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLbl)
        stack.addArrangedSubview(userLbl)

        contentView.addSubview(stack)
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        contentView.preservesSuperviewLayoutMargins = true

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
    }

    required init?(coder: NSCoder) { fatalError("Use programmatic init") }

    func setCell(item: ModelCoreDM) {
        
       
        userLbl.text = item.userName
        titleLbl.text = item.title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = nil
        userLbl.text  = nil
    }
}

import UIKit

final class ScoreCell: UITableViewCell {
    
    static var reuseId = TextLabels.ScoreCell.reuseId
    
    private lazy var recordLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with title: String) {
        recordLabel.text = title
    }
    
    func setupConstraints() {
        addSubview(recordLabel)
        
        NSLayoutConstraint.activate([
            recordLabel.topAnchor.constraint(equalTo: self.topAnchor),
            recordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

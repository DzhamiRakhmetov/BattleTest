import UIKit

final class ScoreViewController: UIViewController {
    
    var cellHeight: CGFloat = 50
    var recordsArray: [Int] = []
    var namesArray: [String] = []
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = TextLabels.ScoreVC.records
        label.font = UIFont.titleForNavItem
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScoreCell.self, forCellReuseIdentifier: ScoreCell.reuseId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        setupNavigation()
        tableView.reloadData()
        loadRecords()
    }
    
    private func setupConstraint() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        let resetScoreButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetRecords))
        navigationItem.rightBarButtonItems = [resetScoreButton]
        navigationItem.titleView = titleLabel
    }
    
    private func loadRecords() {
        let records = UserDefaults.standard.object(forKey: UserDefaultKeys.record.rawValue) as? [Int]
        guard let records = records else { return }
        recordsArray = records
        recordsArray.sort(by: {$0 > $1})
    }
    
    @objc func resetRecords() {
        recordsArray.removeAll()
        tableView.reloadData()
        UserDefaults.standard.set(recordsArray, forKey: UserDefaultKeys.record.rawValue)
    }
}

// MARK: - Extensions

extension ScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreCell.reuseId, for: indexPath) as? ScoreCell else {
            return UITableViewCell()
        }
        cell.configure(with: "\(recordsArray[indexPath.row])")
        return cell
    }
}

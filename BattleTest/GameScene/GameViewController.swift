import UIKit

class GameViewController: UIViewController {
    
    private let cornerRadius: CGFloat = 8
    private let buttonsLabelsFont: CGFloat = 30
    private let buttonsPadding: CGFloat = 30
    private let buttonsHeight: CGFloat = 50
    private let topPadding: CGFloat = 200
    private let buttonsWidth: CGFloat = 280
    
    private lazy var gameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title
        label.text = TextLabels.StartVC.gameLabel
        return label
    }()
    
    private lazy var startButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.setTitle(TextLabels.StartVC.start, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.setTitle(TextLabels.StartVC.settings, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scoreButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.setTitle(TextLabels.StartVC.score, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Funcs
    private func setupViews() {
        view.backgroundColor = .white
        [gameLabel, startButton, settingsButton, scoreButton].forEach {view.addSubview($0)}
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            startButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            
            settingsButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: buttonsPadding),
            settingsButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            settingsButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: buttonsPadding),
            scoreButton.heightAnchor.constraint(equalToConstant: buttonsHeight),
            scoreButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            scoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - @objc funcs
    
    @objc func buttonTapped(_ target: UIButton) {
        var vc: UIViewController
        switch target {
        case startButton:
            vc = StartViewController()
        case settingsButton:
            vc = SettingsViewController()
        case scoreButton:
            vc = ScoreViewController()
        default:
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


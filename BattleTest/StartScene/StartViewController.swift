import UIKit

final class StartViewController: UIViewController {
    
    private var timer: Timer!
    private var enemyImage: UIImageView!
    private var scoreLabel: UILabel!
    private var speedGame = Double()
    private var firstFalling = UIImageView()
    private var secondFalling = UIImageView()
    private var animation = UIViewPropertyAnimator()
    private var airplaine = Airplaine()
    private let alert = AlertAction()
    
    private let enemySize = CGSize(width: 50, height: 50)
    private let scoreLabelSize = CGSize(width: 100, height: 100)
    private var randomXCoordinate: CGFloat {CGFloat.random(in: 0...view.bounds.width - enemySize.width)}
    
    private var score: Int = 0
    private var boardFrames: [CGRect] = []
    private var resultScoreArray: [Int] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupBackgroudViews()
        startAnimatingBackground()
        setupAirplaine()
        setupScoreLabel()
        addGestureFor(airplaine: airplaine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
        loadSpeedLevel()
        loadAirplaine()
        setupEnemy()
        timer = .scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(enemyIntersects), userInfo: nil, repeats: true)
    }
    
    // MARK: - UserDefaults
    
    private func loadRecords() {
        let recordScore = UserDefaults.standard.object(forKey: UserDefaultKeys.record.rawValue) as? [Int]
        guard let recordScore = recordScore else { return }
        resultScoreArray = recordScore
    }
    
    private func loadSpeedLevel() {
        let speedLevel = UserDefaults.standard.value(SettingsModel.self, forKey: UserDefaultKeys.model.rawValue)
        guard let speedLevel = speedLevel else { return }
        speedGame = speedLevel.stepperValue
    }
    
    private func loadAirplaine() {
        let airplaine = UserDefaults.standard.object(forKey: UserDefaultKeys.airplaine.rawValue) as? String
        guard let airplaine = airplaine else { return }
        self.airplaine.image = UIImage(named: airplaine)
    }
    
    // MARK: - Настройка Счетчика
    
    private func setupScoreLabel() {
        let scorelabelFrame = CGRect(x: view.bounds.width - scoreLabelSize.width - 10,
                                     y: 10,
                                     width: scoreLabelSize.width,
                                     height: scoreLabelSize.height)
        scoreLabel = UILabel(frame: scorelabelFrame)
        scoreLabel.textAlignment = .center
        scoreLabel.text = "0"
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.title
        view.addSubview(scoreLabel)
    }
    
    //MARK: - Настройка Background
    
    private func setupBackgroudViews() {
        firstFalling = createFallingImageView()
        secondFalling = createFallingImageView()
        
        view.addSubview(firstFalling)
        view.addSubview(secondFalling)
    }
    
    private func createFallingImageView() -> UIImageView {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func startAnimatingBackground() {
        animateBackground(imageView: firstFalling, delay: 0)
        animateBackground(imageView: secondFalling, delay: 2)
    }
    
    private func animateBackground(imageView: UIImageView, delay: TimeInterval) {
        imageView.frame.origin.y = -imageView.frame.height
        
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .curveLinear], animations: { [weak self] in
            imageView.frame.origin.y = self?.view.frame.height ?? 0 }, completion: nil)
    }
    
    //MARK: - Жесты
    
    private func addGestureFor(airplaine: UIImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(tap(sender:)))
        airplaine.isUserInteractionEnabled = true
        airplaine.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Настройка врага
    
    private func setupEnemy() {
        let enemyFrame = CGRect(origin: CGPoint(x: randomXCoordinate, y: 0), size: enemySize)
        enemyImage = UIImageView(frame: enemyFrame)
        enemyImage.image = UIImage(named: "Enemy")
        view.addSubview(enemyImage)
        animateEnemy()
    }
    
    private func animateEnemy() {
        animation = .runningPropertyAnimator(withDuration: speedGame,
                                             delay: 0,
                                             animations: { [ self] in
            enemyImage.frame.origin.y += view.bounds.height},
                                             completion: { [self] _ in
            score += 1
            scoreLabel.text = String(score)
            enemyImage.frame.origin.x = randomXCoordinate
            enemyImage.frame.origin.y = 0
            enemyImage.image = UIImage(named: "Enemy")
            animateEnemy()
        })
        animation.startAnimation()
    }
    
    //MARK: - Настройка самолета
    
    private func moveAirplaine(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let new = CGPoint(x: view.center.x + translation.x,
                          y: view.center.y)
        
        if airplaine.airplaineStep(to: new, view: self.view, boardFrames: boardFrames) {
            airplaine.airplaineCenter = new
            airplaine.updateViewPosition()
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    private func setupAirplaine() {
        let airY = view.bounds.height - airplaine.airplaineSize.height * 2
        
        let frameImage = CGRect(origin: CGPoint(x: view.bounds.width / 2 - airplaine.airplaineSize.width / 2,
                                                y: airY - airplaine.airplaineSize.height),
                                size: airplaine.airplaineSize)
        airplaine = Airplaine(frame: frameImage)
        airplaine.image = UIImage(named: "AirplaineOne")
        airplaine.airplaineCenter = airplaine.center
        view.addSubview(airplaine)
    }
    
    // MARK: - @objc funcs
    
    @objc func tap(sender: UIPanGestureRecognizer) {
        let airplaineView = sender.view!
        
        switch sender.state {
        case .began, .changed:
            moveAirplaine(view: airplaineView, sender: sender)
        default:
            return
        }
    }
    
    @objc func enemyIntersects() {
        let dynamicEnemyFrame = enemyImage.layer.presentation()?.frame
        let enemyFramesArray = [dynamicEnemyFrame]
        
        for enemy in enemyFramesArray {
            guard let enemy = enemy else { return }
            if airplaine.frame.intersects(enemy) {
                airplaine.image = UIImage(named: "Boom")
                animation.stopAnimation(true)
                enemyImage.removeFromSuperview()
                timer.invalidate()
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {  [self] _ in
                    airplaine.removeFromSuperview()
                    alert.gameOverAlert(self, score: score, result: resultScoreArray)
                }
            }
        }
    }
}


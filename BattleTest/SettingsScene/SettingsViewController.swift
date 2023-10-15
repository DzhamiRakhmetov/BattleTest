import UIKit

final class SettingsViewController: UIViewController {
    private let firstAirplaineImage = UIImage(named: TextLabels.Images.airplaineOne)
    private let secondAirplainetImage = UIImage(named: TextLabels.Images.airplaineTwo)
    private let thirdAirplaineImage = UIImage(named: TextLabels.Images.airplaineThree)

    private var imageFrame: CGRect!
    private let indent: CGFloat = 16
    private let topIndent: CGFloat = 30
    private let cellHeight: CGFloat = 50
    private let saveButtonHeight: CGFloat = 50
    private let stepperSize: CGFloat = 100
    private let airplaneSize: CGFloat = 150
    private let scrollSize: CGFloat = 150
    private let saveButtonWidth: CGFloat = 150
    private let imageViewSize: CGFloat = 200
    private let scrollView = UIScrollView()
    
    private lazy var airplaneScrollView: UIScrollView = {
       var scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.contentSize = CGSize(width: scrollSize * 3, height: scrollSize)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = TextLabels.SettingsVC.settings
        label.font = UIFont.titleForNavItem
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 70
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(avatarImageTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = TextLabels.SettingsVC.enterName
        textField.clearButtonMode = .always
        textField.becomeFirstResponder()
        textField.setLeftPaddingPoints(10)
        return textField
    }()
    
    private lazy var stepper: UIStepper = {
        var stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.stepValue = 0.5
        stepper.value = 5
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(tapStepper), for: .touchUpInside)
        return stepper
    }()
    
    private lazy var speedLabel: UILabel = {
        var label = UILabel()
        label.text = TextLabels.SettingsVC.airplaneSpeed
        label.font = UIFont.regular
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stepperValueLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.regular
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5.0"
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        var button = UIButton()
        button.setTitle(TextLabels.SettingsVC.save, for: .normal)
        button.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.titleForNavItem
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        setupUI()
        loadUserDefaults()
        setupAirplaineMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let radius = imageView.bounds.size.height / 2
        imageView.layer.cornerRadius = radius
        dimmingView.layer.cornerRadius = radius
    }
    
    // MARK: - PrivateFunc
    private func setupAirplaineMenu() {
        imageFrame = CGRect(x: 0, y: 0, width: airplaneSize, height: airplaneSize)
        
        let firstAirplaine = newImageView(paramImage: firstAirplaineImage!, paramFrame: imageFrame)
        firstAirplaine.isUserInteractionEnabled = true
        airplaneScrollView.addSubview(firstAirplaine)
        
        imageFrame.origin.x += imageFrame.size.width
        let secondAirplaine = newImageView(paramImage: secondAirplainetImage!, paramFrame: imageFrame)
        secondAirplaine.isUserInteractionEnabled = true
        airplaneScrollView.addSubview(secondAirplaine)
        
        imageFrame.origin.x += imageFrame.size.width
        let thirdAirplaine = newImageView(paramImage: thirdAirplaineImage!, paramFrame: imageFrame)
        thirdAirplaine.isUserInteractionEnabled = true
        airplaneScrollView.addSubview(thirdAirplaine)
        
        let tapGestureFirstAirplaine = UITapGestureRecognizer(target: self, action: #selector(didTapFirstAirplaine(_:)))
        firstAirplaine.addGestureRecognizer(tapGestureFirstAirplaine)
        let tapGestureSecondAirplaine = UITapGestureRecognizer(target: self, action: #selector(didTapSecondAirplaine(_:)))
        secondAirplaine.addGestureRecognizer(tapGestureSecondAirplaine)
        let tapGestureThirdAirplaine = UITapGestureRecognizer(target: self, action: #selector(didTapThirdAirplaine(_:)))
        thirdAirplaine.addGestureRecognizer(tapGestureThirdAirplaine)
    }
    
   private func newImageView(paramImage: UIImage, paramFrame: CGRect) -> UIImageView {
        let result = UIImageView(frame: paramFrame)
        result.frame = paramFrame
        result.contentMode = .scaleAspectFit
        result.image = paramImage
        return result
    }
    
    private func alphaAnimateAirplaine(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            gesture.view?.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                gesture.view?.alpha = 1
            }
        }
    }
    
    // MARK: - User Defaults
    private func loadUserDefaults() {
        let loadAvatar = UserDefaults.standard.object(forKey: UserDefaultKeys.avatarImage.rawValue) as? String
        let model = UserDefaults.standard.value(SettingsModel.self, forKey: UserDefaultKeys.model.rawValue)
        guard let model = model else { return }
        textField.text = model.name
        airplaneScrollView.contentOffset.x = model.scroll
        stepperValueLabel.text = model.loadValue
        stepper.value = model.stepperValue
        imageView.image = loadImage(fileName: loadAvatar ?? "")

    }
    
    @objc func tapSave(_ sender: UIButton) {
        let model = SettingsModel(name: textField.text ?? "",
                                  scroll: scrollView.contentOffset.x ,
                                  loadValue: stepperValueLabel.text ?? "",
                                  stepperValue: stepper.value)
        
        UserDefaults.standard.set(encodable: model, forKey: UserDefaultKeys.model.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - @objc func
    
    @objc func avatarImageTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func tapStepper(_ sender: UIStepper) {
        stepperValueLabel.text = "\(sender.value)"
    }
    
    @objc func didTapFirstAirplaine(_ gesture: UITapGestureRecognizer) {
        UserDefaults.standard.set(TextLabels.Images.airplaineOne, forKey: UserDefaultKeys.airplaine.rawValue)
        alphaAnimateAirplaine(gesture)
    }
    
    @objc func didTapSecondAirplaine(_ gesture: UITapGestureRecognizer) {
        UserDefaults.standard.set(TextLabels.Images.airplaineTwo, forKey: UserDefaultKeys.airplaine.rawValue)
        alphaAnimateAirplaine(gesture)
    }
    
    @objc func didTapThirdAirplaine(_ gesture: UITapGestureRecognizer) {
        UserDefaults.standard.set(TextLabels.Images.airplaineThree, forKey: UserDefaultKeys.airplaine.rawValue)
        alphaAnimateAirplaine(gesture)
    }
}

// MARK: - Extensions UIImagePicker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let savedPhoto = saveImage(image: selectedImage)
            imageView.image = selectedImage
            UserDefaults.standard.set(savedPhoto, forKey: UserDefaultKeys.avatarImage.rawValue)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup UI SettingsViewController
extension SettingsViewController {
    private func setupUI() {
        
        [imageView, dimmingView, overlayButton, textField, airplaneScrollView, stepper, stepperValueLabel, speedLabel, saveButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: saveButtonHeight),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            
            dimmingView.topAnchor.constraint(equalTo: imageView.topAnchor),
            dimmingView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            dimmingView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            dimmingView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            overlayButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            overlayButton.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            overlayButton.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topIndent),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: indent),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indent),
            textField.heightAnchor.constraint(equalToConstant: cellHeight),
            
            airplaneScrollView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: topIndent),
            airplaneScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            airplaneScrollView.heightAnchor.constraint(equalToConstant: scrollSize),
            airplaneScrollView.widthAnchor.constraint(equalToConstant: scrollSize),
            
            speedLabel.topAnchor.constraint(equalTo: airplaneScrollView.bottomAnchor, constant: topIndent),
            speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stepper.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: indent),
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepper.widthAnchor.constraint(equalToConstant: stepperSize),

            stepperValueLabel.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: indent),
            stepperValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: saveButtonHeight),
            saveButton.widthAnchor.constraint(equalToConstant: saveButtonWidth)
        ])
    }
}









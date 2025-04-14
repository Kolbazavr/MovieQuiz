import UIKit

final class QuizViewController: UIViewController, QuizViewControllerProtocol, Coordinating {
    
    var coordinator: Coordinator?
    
    private var presenter: QuizPresenter!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = QuizPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let yesButton = UIButton(type: .system)
    private let noButton = UIButton(type: .system)
    private let questionTextLabel = UILabel()
    private let questionNumberLabel = UILabel()
    private let questionTitleLabel = UILabel()
    private let imageView = MoviePosterView(frame: .zero)
//    private let menuButton = UIButton(type: .system)
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func showAnswerResult(for isCorrect: Bool) {
        changeStateButton(isEnabled: false)
        imageView.setBorderColor(for: isCorrect)
    }
    
    func showQuestion(with step: QuizStepViewModel) {
        changeStateButton(isEnabled: true)
        imageView.showSomething(movieTitle: step.movieTitle, movieImage: step.image)
        questionTextLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
    }
    
    func showAlert(alert: UIAlertController) {
        alert.view.accessibilityIdentifier = "GameOver"
        present(alert, animated: true)
    }
    
    func toggleLoadingState(to isLoading: Bool) {
        if isLoading {
            imageView.resetBorderColor()
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    func pressButton(_ buttonType: Bool) {
        animateButtonPress(buttonType ? yesButton : noButton)
    }
    
    private func animateButtonPress(_ button: UIButton) {
        UIView.animate(withDuration: 0.4) {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn) {
            button.transform = .identity
        }
    }
    
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    @objc private func noButtonPressed(_ sender: Any) {
        pressButton(false)
        presenter.evaluateAnswer(buttonTypePressed: false)
    }
    
    @objc private func yesButtonPressed(_ sender: Any) {
        pressButton(true)
        presenter.evaluateAnswer(buttonTypePressed: true)
    }
}

//MARK: - SetupUI
extension QuizViewController {
    private func setupUI() {
        setupUIElements()
//        setupMenu()
    }
    
    private func setupUIElements() {
        view.backgroundColor = .ypBackgroundSolid
        
        questionTitleLabel.text = "Вопрос:"
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.textColor = .ypWhite
        
        questionNumberLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionNumberLabel.textColor = .ypWhite
        questionNumberLabel.accessibilityIdentifier = "Index"
        
//        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
//        menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
//        let titleStackView = UIStackView(arrangedSubviews: [questionTitleLabel, questionNumberLabel, menuButton])
        let titleStackView = UIStackView(arrangedSubviews: [questionTitleLabel, questionNumberLabel])  //<---- replace with above
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 5
        
        noButton.configure(title: "Нет")
        noButton.accessibilityIdentifier = "No"
        noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        yesButton.configure(title: "Да")
        yesButton.accessibilityIdentifier = "Yes"
        yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 20
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.accessibilityIdentifier = "Poster"
        
        questionTextLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionTextLabel.textColor = .ypWhite
        questionTextLabel.textAlignment = .center
        questionTextLabel.numberOfLines = 0
        
        let mainStackView = UIStackView(arrangedSubviews: [titleStackView, imageView, questionTextLabel, buttonsStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 20
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/2).isActive = true
    }
    
//    private func setupMenu() {
//        let menu = UIMenu(children: [
//            UIAction(title: "Остановите, надо выйти", image: UIImage(systemName: "house")) { [weak self] _ in
//                self?.coordinator?.navigateBack()
//            }
//        ])
//        menuButton.menu = menu
//        menuButton.showsMenuAsPrimaryAction = true
//    }
}

import UIKit

final class HighScoresViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    private var statisticService: StatisticServiceProtocol?
    
    private let menuTitleLabel = UILabel()
    private let highScoresResults = UILabel()
    private let accuracyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.statisticService = StatisticService()
        setupUI()
        fetchHighScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func fetchHighScores() {
        if let highScores = statisticService?.highScores, !highScores.isEmpty {
            let highScoresText = highScores.map { "\($0.correct)/\($0.total) (\(String(format: "%.2f", $0.accuracy))%) Дата: \($0.date)" }
            highScoresResults.text = "\(highScoresText.joined(separator: "\n"))"
            accuracyLabel.text = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
        } else {
            highScoresResults.text = "Тут будут результаты"
            accuracyLabel.text = "А тут средняя точность"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBackgroundSolid
        
        menuTitleLabel.text = "Ваши рекорды"
        menuTitleLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        menuTitleLabel.textColor = .ypWhite
        menuTitleLabel.textAlignment = .center
        menuTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTitleLabel)
        
        highScoresResults.font = UIFont(name: "YSDisplay-Medium", size: 20)
        highScoresResults.textColor = .ypGreen
        highScoresResults.textAlignment = .center
        highScoresResults.numberOfLines = 0
        highScoresResults.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highScoresResults)
        
        accuracyLabel.font = UIFont(name: "YSDisplay-Medium", size: 23)
        accuracyLabel.textColor = .ypGray
        accuracyLabel.textAlignment = .center
        accuracyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accuracyLabel)
        
        NSLayoutConstraint.activate([
            menuTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            highScoresResults.topAnchor.constraint(equalTo: menuTitleLabel.bottomAnchor, constant: 20),
            highScoresResults.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            highScoresResults.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            accuracyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accuracyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accuracyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

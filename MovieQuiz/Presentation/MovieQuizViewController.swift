import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        alertPresenter = AlertPresenter()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        drawLoader(isShown: true)
        presenter.viewController = self
        enableButtons()
    }
    
    //private var currentQuestionIndex: Int = 0
    //private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    func didLoadDataFromServer() {
        
        drawLoader(isShown: false)
        questionFactory?.requestNextQuestion()
    }
    
    private func drawLoader(isShown: Bool) {
          activityIndicator.isHidden = !isShown
          isShown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func showNetworkError(message: String){
        
        drawLoader(isShown: true)
        
        let networkAlertModel = AlertModel (
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"){ [weak self] in
                guard let self = self else { return }
                self.restartGame()
                
            }
        alertPresenter?.showAlert(showController: self, model: networkAlertModel)
    }

    private func restartGame() {
            presenter.resetQuestionIndex()
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            counterLabel.text = step.questionNumber
            textLabel.text = step.question
        }
        
     func showAnswerResult(isCorrect: Bool) {
            
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        drawLoader(isShown: true)
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideAnswerBorder()
                self.showNextQuestionOrResults()
                self.drawLoader(isShown: false)
            }
        }
        
    private func hideAnswerBorder() {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor =  UIColor.clear.cgColor
        }

    private func showNextQuestionOrResults() {
        
            if presenter.isLastQuestion() {
                
                if let statisticService = statisticService {
                    
                    statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
                    
                    let bestGame = statisticService.bestGame
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
                    
                    let alertTitle = "Этот раунд окончен!"
                    let alertButtonText = "Сыграть ещё раз"
                    let alertText = """
                    Ваш результат: \(correctAnswers) из 10
                    Количество сыграных квизов: \(statisticService.gamesCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateFormatter.string(from: bestGame.date)))
                    Средняя точность: (\(String(format: "%.2f", statisticService.totalAccuracy))%)
                    """
                    let resultsAlertModel = AlertModel(title: alertTitle, message: alertText, buttonText: alertButtonText) { [weak self] in
                        guard let self = self else { return }
                        self.restartGame()
                    }
                    alertPresenter?.showAlert(showController: self, model: resultsAlertModel)
                }
            } else {
                presenter.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
            enableButtons()
        }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
}

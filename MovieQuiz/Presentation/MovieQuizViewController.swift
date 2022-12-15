import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    //MARK: - Outlets
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        drawLoader(isShown: true)
        enableButtons()
        
        alertPresenter = AlertPresenter()
        presenter = MovieQuizPresenter(viewController: self)
        presenter.resetQuestionIndex()
        presenter.restartGame()
    }
    
    //MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - functions
    
    func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            counterLabel.text = step.questionNumber
            textLabel.text = step.question
    }
    
    func showNetworkError(message: String){
        
        drawLoader(isShown: true)
        
        let networkAlertModel = AlertModel (
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"){ [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        alertPresenter?.showAlert(showController: self, model: networkAlertModel)
    }
    
    func showEndGame() {
        let alertTitle = "Этот раунд окончен!"
        let alertButtonText = "Сыграть ещё раз"
        let alertText = presenter.getResultsMessage()
        let resultsAlertModel = AlertModel(title: alertTitle, message: alertText, buttonText: alertButtonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(showController: self, model: resultsAlertModel)
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func drawLoader(isShown: Bool) {
          activityIndicator.isHidden = !isShown
          isShown ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showAnswerBorder(isCorrect: Bool){
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
        
    func hideAnswerBorder() {
        imageView.layer.borderColor =  UIColor.clear.cgColor
    }

}

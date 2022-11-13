import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        //showFirstQuestion()
        
    }
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    

    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            counterLabel.text = step.questionNumber
            textLabel.text = step.question
        }
    private func show(quiz result: QuizResultsViewModel) {
            let alertModel = AlertModel(
                title: result.title,
                message: result.text,
                buttonText: result.buttonText)
                { [weak self]  _ in
                    guard let self = self else { return }
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.showAlert(quiz: alertModel)
        }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
                question: model.text, // берём текст вопроса
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
        }
        
    private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                guard let self = self else { return }
                self.hideAnswerBorder()
                self.showNextQuestionOrResults()
            }
        }
        
    private func hideAnswerBorder() {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor =  UIColor.clear.cgColor
        }
        
    private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                let text = "Ваш результат: \(correctAnswers) из 10"
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
                show(quiz: viewModel)
                correctAnswers = 0
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
            }
        }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

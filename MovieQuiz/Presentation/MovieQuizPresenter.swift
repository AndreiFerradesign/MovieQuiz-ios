//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Andrei on 13.12.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticService!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController as? MovieQuizViewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.drawLoader(isShown: true)
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        viewController?.drawLoader(isShown: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
   
    func yesButtonClicked() {
            didAnswer(isYes: true)
    }
        
    func noButtonClicked() {
            didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = isYes
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func restartGame() {
            self.resetQuestionIndex()
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
    }
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
            currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
            currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func showNextQuestionOrResults() {
        
            if self.isLastQuestion() {
                viewController?.showEndGame()
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
            viewController?.enableButtons()
    }
    
    func getResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
            let alertText = """
                Ваш результат: \(correctAnswers) из 10
                Количество сыграных квизов: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateFormatter.string(from: bestGame.date)))
                Средняя точность: (\(String(format: "%.2f", statisticService.totalAccuracy))%)
                """
            return alertText
    }
   
    func showAnswerResult(isCorrect: Bool) {
        viewController?.showAnswerBorder(isCorrect: isCorrect)
          
       if isCorrect {
           correctAnswers += 1
       }
        viewController?.drawLoader(isShown: true)
        viewController?.disableButtons()
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.viewController?.hideAnswerBorder()
           self.viewController?.drawLoader(isShown: false)
           self.showNextQuestionOrResults()
           }
    }
}

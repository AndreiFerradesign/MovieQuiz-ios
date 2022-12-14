//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Andrei on 13.12.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showNetworkError(message: String)
    func showEndGame()
    func enableButtons()
    func disableButtons()
    func drawLoader(isShown: Bool)
    func showAnswerBorder(isCorrect: Bool)
    func hideAnswerBorder()
}

//
//  MovieQuizViewControllerProtocolMock.swift
//  MovieQuizViewControllerProtocolMock
//
//  Created by Andrei on 14.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    func showNetworkError(message: String){
        
    }
    func showEndGame() {
        
    }
    func enableButtons() {
        
    }
    func disableButtons() {
        
    }
    func drawLoader(isShown: Bool) {
        
    }
    func showAnswerBorder(isCorrect: Bool) {
        
    }
    func hideAnswerBorder() {
        
    }

}


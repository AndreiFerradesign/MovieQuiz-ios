//
//  MovieQuizViewControllerProtocolMock.swift
//  MovieQuiz
//
//  Created by Andrei on 14.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func showImageBorder(isCorrect: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
    
    func showNetworkErrorAlert(message: String) {
    }
    
}


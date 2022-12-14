//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Andrei on 14.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
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


class MovieQuizPresenterTest: XCTestCase {
    
    func testPresenterConvertModel() throws {
        
            let viewControllerMock = MovieQuizViewControllerProtocolMock()
            let sut = MovieQuizPresenter(viewController: viewControllerMock)
            
            let emptyData = Data()
            let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
            let viewModel = sut.convert(model: question)
            
             XCTAssertNotNil(viewModel.image)
            XCTAssertEqual(viewModel.question, "Question Text")
            XCTAssertEqual(viewModel.questionNumber, "1/10")
        }
    
}

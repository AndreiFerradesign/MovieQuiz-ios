//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andrei on 12.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject  {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}




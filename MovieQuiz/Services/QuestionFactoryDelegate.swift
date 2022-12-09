//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andrei on 12.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}



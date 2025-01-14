//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Andrei on 07.11.2022.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    enum ApiError: Error {
        case responseError(String)
        case imageError(String)
    }
    func loadData() {
            moviesLoader.loadMovies { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let mostPopularMovies):
                        let apiErrorMessage = mostPopularMovies.errorMessage
                        if apiErrorMessage.isEmpty {
                            self.movies = mostPopularMovies.items
                            self.delegate?.didLoadDataFromServer() }
                        else {
                            self.delegate?.didFailToLoadData(with: ApiError.responseError(apiErrorMessage))
                        }
                    case.failure(let error):
                        self.delegate?.didFailToLoadData(with: error)
                    }
                }
            }
        }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
           do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                let imageLoadingError = "Unable to load image: " + movie.imageURL.absoluteString
                self.delegate?.didFailToLoadData(with: ApiError.imageError(imageLoadingError))
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

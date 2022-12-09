//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Andrei on 20.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void )
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
           // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
           guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_ko861d5d") else {
               preconditionFailure("Unable to construct mostPopularMoviesUrl")
           }
           return url
       }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void ) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
                 switch result {
                 case .success(let data):
                     do {
                         let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                         handler(.success(movies))
                     } catch let jsonError {
                         handler(.failure(jsonError))
                     }
                 case .failure(let responseError):
                     handler(.failure(responseError))
            }
        }
    }
}
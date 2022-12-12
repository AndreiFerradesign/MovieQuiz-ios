//
//  MoviesLoaderTests.swift
//  MoviesLoaderTests
//
//  Created by Andrei on 12.12.2022.
//

import XCTest
@testable import MovieQuiz // импортируем приложение для тестирования

class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(_):
                // сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
       
       waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
       
            let stubNetworkClient = StubNetworkClient(emulateError: true)
            let loader = MoviesLoader(networkClient: stubNetworkClient)
            let expectation = expectation(description: "Loading expectation")
            
            loader.loadMovies { result in
                // Then
                switch result {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .success(_):
                    XCTFail("Unexpected failure")
                }
            }
            
            waitForExpectations(timeout: 1)
        }
}


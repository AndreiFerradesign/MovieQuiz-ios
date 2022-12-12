//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Andrei on 12.12.2022.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testNoButton() {
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["No"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    func testYesButton() {
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    func testResultAlertShow() {
            let expectedAlertTitle = "Этот раунд окончен!"
            let expectedButtonLabel = "Сыграть ещё раз"
            
            for _ in 1...10 {
                app.buttons["Yes"].tap()
                sleep(1)
            }
            
            sleep(3)
            
            let alert = app.alerts[expectedAlertTitle]
            XCTAssertTrue(app.alerts[expectedAlertTitle].exists)
            XCTAssertTrue(alert.label == expectedAlertTitle)
            XCTAssertTrue(alert.buttons.firstMatch.label == expectedButtonLabel)
        }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

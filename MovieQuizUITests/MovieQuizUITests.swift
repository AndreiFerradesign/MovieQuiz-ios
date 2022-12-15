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
        
        let myImageFirst = XCUIApplication().images["Poster"]
        let firstPoster = myImageFirst.screenshot()
    
        app.buttons["No"].tap()
        
        let myImageSecond = XCUIApplication().images["Poster"]
        let secondPoster = myImageSecond.screenshot()
        let indexLabel = app.staticTexts["Index"]
        
        sleep(2)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertNotEqual(firstPoster.pngRepresentation, secondPoster.pngRepresentation)
    }
    
    func testYesButton() {
        
        let myImageFirst = XCUIApplication().images["Poster"]
        let firstPoster = myImageFirst.screenshot()
    
        app.buttons["Yes"].tap()
        
        let myImageSecond = XCUIApplication().images["Poster"]
        let secondPoster = myImageSecond.screenshot()
        let indexLabel = app.staticTexts["Index"]
        
        sleep(2)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertNotEqual(firstPoster.pngRepresentation, secondPoster.pngRepresentation)
    }
    
    func testResultAlertShow() {
            let expectedAlertTitle = "Этот раунд окончен!"
            let expectedButtonLabel = "Сыграть ещё раз"
            
            for _ in 1...10 {
                app.buttons["Yes"].tap()
                sleep(1)
            }
            
        sleep(2)
            
            let alert = app.alerts[expectedAlertTitle]
            XCTAssertTrue(app.alerts[expectedAlertTitle].exists)
            XCTAssertTrue(alert.label == expectedAlertTitle)
            XCTAssertTrue(alert.buttons.firstMatch.label == expectedButtonLabel)
        }
    
    func testAlertDismiss() {
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        
        sleep(1)
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

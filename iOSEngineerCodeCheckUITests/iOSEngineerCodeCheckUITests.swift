//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields.allElementsBoundByIndex.first
        XCTAssert(searchField?.exists ?? false)
        searchField?.tap()
        searchField?.typeText("Swift")
        app.buttons["search"].tap()
        
        let cell = app.staticTexts["apple/swift"]
        XCTAssert(cell.waitForExistence(timeout: 5))
        cell.tap()
        
        let navigationButton = app.buttons["Root View Controller"]
        XCTAssert(navigationButton.waitForExistence(timeout: 5))
        
        let issuesText = app.staticTexts.allElementsBoundByIndex.first(where: { (element) in
            print(element)
            return element.label.contains("open issues")
        })
        XCTAssert(issuesText?.exists ?? false)
        
    }
    
 

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

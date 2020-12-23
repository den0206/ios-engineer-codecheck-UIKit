//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        
        continueAfterFailure = false
        
        XCUIApplication().launch()
        
    }
    
    override func tearDown() {
        super.tearDown()
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
        
        //        let navigationButton = app.buttons["Root View Controller"]
        //        XCTAssert(navigationButton.waitForExistence(timeout: 5))
        //
        //        let issuesText = app.staticTexts.allElementsBoundByIndex.first(where: { (element) in
        //            print(element)
        //            return element.label.contains("open issues")
        //        })
        //        XCTAssert(issuesText?.exists ?? false)
        
    }
    
}

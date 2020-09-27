//
//  Message_BoardUITests.swift
//  Message BoardUITests
//
//  Created by Spencer Curtis on 9/14/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import XCTest

class Message_BoardUITests: XCTestCase {
    
    private var app: XCUIApplication {
        XCUIApplication()
    }
    
    private var titleTextField: XCUIElement {
        return app.textFields["Create a new thread:"]
    }
    
    private var createThreadTextField: XCUIElement {
        app.textFields["CreateThreadTextField"]
    }
    
    private var tableView: XCUIElementQuery {
        app.tables
    }
    
    private var nameTextField: XCUIElement {
        app.textFields["Enter your name:"]
    }
    
    private var navBar: XCUIElementQuery {
        app.navigationBars
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // NOTE: Keep this setup as is for UI Testing
        app.launchArguments = ["UITesting"]
        app.launch()
    }
    
    func testCreateThread() {
        XCTAssert(titleTextField.exists)
        titleTextField.tap()
        titleTextField.typeText("I am a UI Testing God!")
        app.buttons["Return"].tap()
        XCTAssert(tableView.staticTexts["I am a UI Testing God!"].exists)
    }
}

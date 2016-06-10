//
//  UASAppUITests.swift
//  UASAppUITests
//
//  Created by Karl Montenegro on 02/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import XCTest

class UASAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let device = XCUIDevice.sharedDevice()
        device.orientation = .LandscapeLeft
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCantLoginWithNoData() {
        
        let app = XCUIApplication()
        app.buttons["Iniciar Sesión"].tap()
        
        let usernameField = app.textFields["Usuario"]
        
        XCTAssert(usernameField.exists)
        
    }
    
    func testCanLogin() {
        
        let app = XCUIApplication()
        
        let usernameField = app.textFields["Usuario"]
        usernameField.tap()
        usernameField.typeText("admin")
        
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        
        let passwordField = app.secureTextFields["Contraseña"]
        passwordField.tap()
        passwordField.typeText("secret")
        hideKeyboardButton.tap()
        
        
        app.buttons["Iniciar Sesión"].tap()
        
        let errorAlert = app.alerts["Error"]
        XCTAssertFalse(errorAlert.exists)
        
    }
    

}

//
//  FacultiesTest.swift
//  UASApp
//
//  Created by José Carlos Pereyra on 6/3/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import XCTest

class FacultiesTest: XCTestCase {
    
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
    
    func login() {
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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanLogout() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        login()
        let app = XCUIApplication()
        
        app.navigationBars["Especialidades"].buttons["Cerrar Sesión"].tap()
        
        let okButton = app.alerts["Atención"].collectionViews.buttons["OK"]
        okButton.tap()
 
        let usernameField = app.textFields["Usuario"]
        
        XCTAssert(usernameField.exists)
        
    }
    
    func testCanEnterFaculty() {
        login()
        
        let app = XCUIApplication()
        
        let firstOption = app.tables.cells.elementBoundByIndex(0)
        firstOption.tap()
        
        let tablesQuery = XCUIApplication().tables
        let firstOptionInMenuExists = tablesQuery.staticTexts["Inicio"].exists
        
        XCTAssert(firstOptionInMenuExists)
    }

    func testOE() {
        login()
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        tablesQuery.staticTexts["Objetivos Educacionales"].tap()
    }
    
    func testEnterOE() {
        login()
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        tablesQuery.staticTexts["Objetivos Educacionales"].tap()
        tablesQuery.staticTexts["Objetivo Educacional 3: Diseñar sistemas, componentes o procesos que satisfagan las necesidades presentadas"].tap()
    }
    
    func testRE() {
        login()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        XCUIApplication().tables.staticTexts["Resultados Estudiantiles"].tap()
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
    }
    
    func testEnterRE() {
        login()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        XCUIApplication().tables.staticTexts["Resultados Estudiantiles"].tap()
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        
    }
    
    func testAspects() {
        login()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        tablesQuery.staticTexts["Aspectos"].tap()
        
    }
    
    func testEnterAspects() {
        login()
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Ingeniería Informática"].tap()
        tablesQuery.staticTexts["Aspectos"].tap()
        tablesQuery.staticTexts["Matematicas"].tap()
        
    }
    
    func testCourses() {
        login()
        XCUIApplication().tables.staticTexts["Ingeniería Informática"].tap()
        XCUIDevice.sharedDevice().orientation = .LandscapeLeft
        
        let app = XCUIApplication()
        app.tables.staticTexts["Cursos"].tap()
        
        }
    
    func testEnterCourses() {
        login()
        XCUIApplication().tables.staticTexts["Ingeniería Informática"].tap()
        XCUIDevice.sharedDevice().orientation = .LandscapeLeft
        
        let app = XCUIApplication()
        app.tables.staticTexts["Cursos"].tap()
        XCUIApplication().tables.staticTexts["INF245 - Tesis 1"].tap()

    }
    
    func testContinuosImprovement() {
        login()
        XCUIApplication().tables.staticTexts["Ingeniería Informática"].tap()
        XCUIApplication().tables.staticTexts["Mejora Contínua"].tap()
        
    }
    
    func testSugerencias() {
        login()
        XCUIApplication().tables.staticTexts["Ingeniería Informática"].tap()
        
        XCUIApplication().tables.staticTexts["Mejora Contínua"].tap()
        XCUIApplication().tabBars.buttons["Sugerencias"].tap()
        
    }
}

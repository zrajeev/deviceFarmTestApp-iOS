//
//  ZIAPDemoUITests.swift
//  ZIAPDemoUITests
//
//  Copyright © 2018 Zimperium. All rights reserved.
//

import XCTest

class ZIAPDemoUITests: XCTestCase {
    
    let app = XCUIApplication()
   
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
      app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testActivatezIAP() {
        
        sleep(20);
        
        let buttons = app.buttons.allElementsBoundByAccessibilityElement
        
        for b in buttons {
            
                        b.tap()
           
            sleep(5);
            
        }
        
        sleep(10);
    }
    
    
    
    
}

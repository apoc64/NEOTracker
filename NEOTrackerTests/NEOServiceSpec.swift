//
//  NEOServiceSpec.swift
//  NEOTrackerTests
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import NEOTracker

class NEOServiceTest: XCTestCase {
    
    override func setUp() {
        MockServer.setup()
    }
            
    func testNEOResponse() {
        let exp = expectation(description: "NEO service completion")
        NEO.requestNeos(completion: { (neos, error) in
            XCTAssert(error == nil)
            XCTAssert(neos?.count == 20)
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
}

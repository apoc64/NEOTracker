//
//  XCTestCaseExtensions.swift
//  NEOTrackerTests
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation
import XCTest

class TestCase: XCTestCase {
    
    var exp: XCTestExpectation?
    
    override func setUp() {
        MockServer.setup()
        exp = expectation(description: "Service Completion")
    }
    
    func wait(time: TimeInterval = 1.0) {
        waitForExpectations(timeout: time, handler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func done() {
        exp?.fulfill()
    }
}

public func expect(_ expression: Bool) {
    XCTAssert(expression)
}

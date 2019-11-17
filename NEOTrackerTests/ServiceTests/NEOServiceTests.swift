//
//  NEOServiceSpec.swift
//  NEOTrackerTests
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import NEOTracker

class NEOServiceTest: TestCase {
            
    func testNEOResponse() {
        NEO.requestNeos(completion: { (neos, error) in
            expect(error == nil)
            expect(neos?.count == 20)
            self.done()
        })
        
        wait()
    }
}

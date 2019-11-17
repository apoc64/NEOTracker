//
//  ContentViewTests.swift
//  NEOTrackerTests
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import XCTest
@testable import NEOTracker

class ContentViewTests: TestCase {
    
    func testShowingNEOS() {
        let view = ContentView()
        view.fetchNeos()
        // How to handle?
        expect(true)
        done()
        wait()
    }
}

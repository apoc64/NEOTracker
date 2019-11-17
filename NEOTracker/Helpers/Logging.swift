//
//  Logging.swift
//  NEOTracker
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation

// Global logging function. Rewrite, consider production/analytics
public func log(_ message: String) {
    #if DEBUG
        print("\(DateFormatter.timestamp): \(message)")
    #endif
}

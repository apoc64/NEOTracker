//
//  DateFormatterExtensions.swift
//  NEOTracker
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let basicTimeFormatter = createBasicTimeFormatter()
    private static func createBasicTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterStyle.basicTimeFormatter.rawValue
        return dateFormatter
    }
    
    static let basicDateTimeFormatter = createBasicDateTimeFormatter()
    private static func createBasicDateTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterStyle.basicDateTimeFormatter.rawValue
        return dateFormatter
    }
    
    static func string(date: Date, style: DateFormatterStyle) -> String {
        return style.formatter.string(from: date)
    }
    
    static var timestamp: String {
        return string(date: Date(), style: .basicTimeFormatter)
    }
    
    static var dateTimeStamp: String {
        return string(date: Date(), style: .basicDateTimeFormatter)
    }
}

enum DateFormatterStyle: String {
    case basicTimeFormatter = "HH:mm:ss.SS"
    case basicDateTimeFormatter = "MM/DD/YY HH:mm:ss"
    
    var formatter: DateFormatter {
        switch self {
        case .basicTimeFormatter:
            return DateFormatter.basicTimeFormatter
        case .basicDateTimeFormatter:
            return DateFormatter.basicDateTimeFormatter
        }
    }
}

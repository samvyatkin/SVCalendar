//
//  SVDateExtension.swift
//  SVCalendarView
//
//  Created by Sam on 18/12/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

extension Date {
    static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        
        return formatter
    }
    
    func convertWith(format: String) -> String {        
        return Date.formatter(format).string(from: self)
    }
}

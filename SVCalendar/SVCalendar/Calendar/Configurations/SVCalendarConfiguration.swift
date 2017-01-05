//
//  SVCalendarConfiguration.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

struct SVCalendarType: OptionSet, Hashable {
    public let rawValue: Int
    public var hashValue: Int {
        return rawValue
    }
    
    static let all = SVCalendarType(rawValue: 0)
    static let day = SVCalendarType(rawValue: 1 << 0)
    static let week = SVCalendarType(rawValue: 1 << 1)
    static let month = SVCalendarType(rawValue: 1 << 2)
    static let quarter = SVCalendarType(rawValue: 1 << 3)
    static let year = SVCalendarType(rawValue: 1 << 4)
    
    static let defaultTypes = [SVCalendarType.day, SVCalendarType.month, SVCalendarType.year]    
}

public class SVCalendarConfiguration {
    static let shared = SVCalendarConfiguration()
    
    struct Style {
        var container = SVCalendarStyle(for: .container)
        var calendar = SVCalendarStyle(for: .calendar)
        var navigation = SVCalendarStyle(for: .navigation)
        var switcher = SVCalendarStyle(for: .switcher)
        var header1 = SVCalendarStyle(for: .header1)
        var header2 = SVCalendarStyle(for: .header2)
        var time = SVCalendarStyle(for: .time)
        var cell = SVCalendarStyle(for: .cell)
    }
    
    var types: [SVCalendarType] {
        return [SVCalendarType.month]
    }
    var minYear: Int = 2000
    var maxYear: Int = 2020
    
    var styles = Style()
    
    var isStyleDefault = true
    var isSwitcherVisible = true
    var isNavigationVisible = true
    var isHeaderSection1Visible = true
    var isHeaderSection2Visible = false
    var isTimeSectionVisible = false
}

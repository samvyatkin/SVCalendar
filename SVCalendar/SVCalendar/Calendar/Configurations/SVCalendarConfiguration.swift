//
//  SVCalendarConfiguration.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

public struct SVCalendarType: OptionSet, Hashable {
    public let rawValue: Int
    public var hashValue: Int {
        return rawValue
    }
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
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
    public static let shared = SVCalendarConfiguration()
    
    public init() {}
    
    public struct Style {
        var container = SVCalendarStyle(for: .container)
        var calendar = SVCalendarStyle(for: .calendar)
        var navigation = SVCalendarStyle(for: .navigation)
        var switcher = SVCalendarStyle(for: .switcher)
        var header1 = SVCalendarStyle(for: .header1)
        var header2 = SVCalendarStyle(for: .header2)
        var time = SVCalendarStyle(for: .time)
        var cell = SVCalendarStyle(for: .cell)
    }
    
    public var types: [SVCalendarType] {
        return [SVCalendarType.month]
    }
    public var minYear: Int = 2000
    public var maxYear: Int = 2020
    
    public var styles = Style()
    
    public var isStyleDefault = true
    public var isSwitcherVisible = true
    public var isNavigationVisible = true
    public var isHeaderSection1Visible = true
    public var isHeaderSection2Visible = false
    public var isTimeSectionVisible = false
}

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

/**
 Protocol describe's properties and methods which available in configuration
*/

public protocol SVConfigurationProtocol {
    var style: SVStyleProtocol { get set }
    
    init()
}

public struct SVContainerConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVContainerStyle()
    public init() {}
}

public struct SVCalendarConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVCalendarStyle()
    
    public var types: [SVCalendarType] {
        return SVCalendarType.defaultTypes
    }
    
    public var minYear: Int = 2000
    public var maxYear: Int = 2020
    
    public var isStyleDefault = true
    public var isSwitcherVisible = true
    public var isNavigationVisible = true
    public var isHeaderSection1Visible = true
    public var isHeaderSection2Visible = false
    public var isTimeSectionVisible = false
    
    public init() {}
}

public struct SVSwitcherConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVSwitcherStyle()
    public init() {}
}

public struct SVNavigationConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVNavigationStyle()
    public init() {}
}

public struct SVHeader1Configuration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVHeader1Style()
    public init() {}
}

public struct SVHeader2Configuration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVHeader2Style()
    public init() {}
}

public struct SVTimeConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVTimeStyle()
    public init() {}
}

public struct SVCellConfiguration: SVConfigurationProtocol {
    public var style: SVStyleProtocol = SVCellStyle()
    public init() {}
}

public struct SVConfiguration {
    public var calendar = SVCalendarConfiguration()
    public var container = SVContainerConfiguration()
    public var switcher = SVSwitcherConfiguration()
    public var navigation = SVNavigationConfiguration()
    public var header1 = SVHeader1Configuration()
    public var header2 = SVHeader2Configuration()
    public var time = SVTimeConfiguration()
    public var cell = SVCellConfiguration()
    
    public init() {}
}

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
    
    static let defaultTypes = [SVCalendarType.day, SVCalendarType.week, SVCalendarType.month]
}

/**
 Protocol describe's properties and methods which available in configuration
*/

public protocol SVConfigurationProtocol {
    associatedtype SVStyleType
    var style: SVStyleType { get set }
    
    init()
}

public struct SVContainerConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVStyleProtocol
    public var style: SVStyleType = SVContainerStyle()
    public init() {}
}

public struct SVCalendarConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVCalendarStyle
    
    public var style: SVStyleType = SVCalendarStyle()
    public var types = SVCalendarType.defaultTypes
    
    public var minYear: Int = 2000
    public var maxYear: Int = 2020
    
    public var isStyleDefault = true
    public var isSwitcherVisible = true
    public var isNavigationVisible = true
    public var isHeaderSection1Visible = true
    public var isHeaderSection2Visible = false
    
    public init() {}
}

public struct SVSwitcherConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVSwitcherStyle
    public var style: SVStyleType = SVSwitcherStyle()
    public init() {}
}

public struct SVNavigationConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVNavigationStyle
    public var style: SVStyleType = SVNavigationStyle()
    public init() {}
}

public struct SVHeader1Configuration: SVConfigurationProtocol {
    public typealias SVStyleType = SVHeader1Style
    public var style: SVStyleType = SVHeader1Style()
    public init() {}
}

public struct SVHeader2Configuration: SVConfigurationProtocol {
    public typealias SVStyleType = SVHeader2Style
    public var style: SVStyleType = SVHeader2Style()
    public init() {}
}

public struct SVTimeConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVTimeStyle
    public var style: SVStyleType = SVTimeStyle()    
    public init() {}
}

public struct SVCellConfiguration: SVConfigurationProtocol {
    public typealias SVStyleType = SVCellStyle
    public var style: SVStyleType = SVCellStyle()
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

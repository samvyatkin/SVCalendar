//
//  SVCalendarDate.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 19/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

/**
 Calendar date
 This struct keep info for special date
 */

protocol SVCalendarDateProtocol {
    var isCurrent: Bool { get }
    var isEnabled: Bool { get }
    var isWeekend: Bool { get }
    var title: String { get }
    var value: Date { get }
    var type: SVCalendarType { get }
    
    init(isEnabled: Bool, isCurrent: Bool, isWeekend: Bool, title: String, value: Date, type: SVCalendarType)
}

public struct SVCalendarDate: SVCalendarDateProtocol {
    var isCurrent: Bool = false
    var isEnabled: Bool = true
    var isWeekend: Bool = false
    var title: String
    var value: Date
    var type: SVCalendarType
    
    init(isEnabled: Bool, isCurrent: Bool, isWeekend: Bool, title: String, value: Date, type: SVCalendarType) {
        self.isEnabled = isEnabled
        self.isCurrent = isCurrent
        self.isWeekend = isWeekend
        self.title = title
        self.value = value
        self.type = type
    }
}

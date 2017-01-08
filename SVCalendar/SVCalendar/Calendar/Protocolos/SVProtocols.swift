//
//  SVProtocols.swift
//  SVCalendarView
//
//  Created by Sam on 17/12/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

public protocol SVCalendarDelegate: class {
    func didSelectDate(_ date: Date)
    func didChangeDateDimension(_ type: SVCalendarType)
}

public protocol SVCalendarNavigationDelegate: class {
    func didChangeNavigationDate(direction: SVCalendarNavigationDirection) -> String?
}

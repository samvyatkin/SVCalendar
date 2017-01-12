//
//  SVCalendarViewDayCell.swift
//  SVCalendar
//
//  Created by Sam on 13/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewDayCell: SVCalendarViewBaseCell {

    static var identifier: String {
        return NSStringFromClass(SVCalendarViewDayCell.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
}

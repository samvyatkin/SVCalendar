//
//  SVCalendarService.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation

/** 
 Calendar Brain
 This class contains all logic which will creates calendar with different dimensions (e.g. day, week, month, quarter and year)
*/

struct SVCalendarDateFormat {
    static let short = "dd.MM.yyyy"
    static let full = "dd EEEE, MMMM yyyy"
    static let monthYear = "MMMM yyyy"
}

class SVCalendarService {
    fileprivate let components: Set<Calendar.Component> = [
        .second, .minute, .hour, .day, .weekday, .weekOfMonth, .month, .quarter, .year
    ]
    
    enum SVCalendarWeekDays: Int {
        case mon = 2
        case tue = 3
        case wed = 4
        case thu = 5
        case fri = 6
        case sat = 7
        case sun = 1
    }
    
    fileprivate let types: [SVCalendarType]
    fileprivate lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = SVCalendarWeekDays.mon.rawValue
        calendar.minimumDaysInFirstWeek = 7
        
        return calendar
    }()
    
    fileprivate var currentDate: Date {
        return calendar.date(from: currentComponents)!
    }
    
    fileprivate var currentComponents: DateComponents {
        return calendar.dateComponents(components, from: Date())
    }
    
    fileprivate var visibleDate: Date!
    fileprivate var calendarDates = [SVCalendarType : [SVCalendarDate]]()
    fileprivate var calendarTitles = [SVCalendarType : [String]]()
    
    var updatedDate: Date {
        return self.visibleDate
    }
    
    // MARK: - Calendar Brain LifeCycle
    init(types: [SVCalendarType]) {
        self.types = types
        self.visibleDate = currentDate
        
        updateCalendarDates()
        updateCaledarTitles()
    }
    
    deinit {
        removeAllDates()
    }
    
    // MARK: - Calendar Methods
    fileprivate func updateCalendarDates() {
        if types.contains(SVCalendarType.all) {
            calendarDates[.year] = configYearDates()
            calendarDates[.quarter] = configQuarterDates()
            calendarDates[.month] = configMonthDates()
            calendarDates[.week] = configWeekDates()
            calendarDates[.day] = configDayDates()
            return
        }
        
        if types.contains(SVCalendarType.year) {
            calendarDates[.year] = configYearDates()
        }
        
        if types.contains(SVCalendarType.quarter) {
            calendarDates[.quarter] = configQuarterDates()
        }
        
        if types.contains(SVCalendarType.month) {
            calendarDates[.month] = configMonthDates()
        }
        
        if types.contains(SVCalendarType.week) {
            calendarDates[.week] = configWeekDates()
        }
        
        if types.contains(SVCalendarType.day) {
            calendarDates[.day] = configDayDates()
        }
    }
    
    func updateCaledarTitles() {
        if types.contains(SVCalendarType.all) {
            calendarTitles[.year] = calendar.shortMonthSymbols
            calendarTitles[.quarter] = calendar.shortQuarterSymbols
            calendarTitles[.month] = calendar.shortWeekdaySymbols
            calendarTitles[.week] = calendar.shortWeekdaySymbols
            calendarTitles[.day] = calendar.shortWeekdaySymbols
            return
        }
        
        if types.contains(SVCalendarType.quarter) {
            calendarTitles[.year] = calendar.shortMonthSymbols
        }
        
        if types.contains(SVCalendarType.quarter) {
            calendarTitles[.quarter] = calendar.shortMonthSymbols
        }
        
        if types.contains(SVCalendarType.month) {
            calendarTitles[.month] = calendar.shortWeekdaySymbols
        }
        
        if types.contains(SVCalendarType.week) {
            calendarTitles[.week] = calendar.shortWeekdaySymbols
        }
        
        if types.contains(SVCalendarType.day) {
            calendarTitles[.day] = calendar.shortWeekdaySymbols
        }
    }
    
    func updateDate(for calendarType: SVCalendarType, isDateIncrease: Bool) {
        var dateComponents = calendar.dateComponents(components, from: visibleDate)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        let sign = isDateIncrease ? 1 : -1
        
        switch calendarType {
        case SVCalendarType.day:
            dateComponents.day! += sign
            break
        case SVCalendarType.week:
            dateComponents.day! += sign * 7
            break
        case SVCalendarType.month:
            dateComponents.month! += sign
            break
        case SVCalendarType.quarter:
            dateComponents.quarter! += sign
            break
        case SVCalendarType.year:
            dateComponents.year! += sign
            break
        default:
            break
        }
        
        visibleDate = calendar.date(from: dateComponents)!
        
        removeAllDates()
        updateCalendarDates()
        updateCaledarTitles()
    }
    
    func dates(for type: SVCalendarType) -> [SVCalendarDate] {
        guard let dates = calendarDates[type] else {
            return []
        }
        
        return dates
    }
    
    func titles(for type: SVCalendarType) -> [String] {
        guard let titles = calendarTitles[type] else {
            return []
        }
        
        return titles
    }
    
    func dateComponents(from date: Date) -> DateComponents {
        return calendar.dateComponents(components, from: date)
    }
    
    fileprivate func removeAllDates() {
        calendarDates.removeAll()
        calendarTitles.removeAll()
    }
    
    // MARK: - Year Dates
    fileprivate func yearDateComponents(from date: Date, for year: Int) -> DateComponents {
        var dateComponents = calendar.dateComponents(components, from: date)
        dateComponents.year = year
        dateComponents.month = 1
        dateComponents.weekday = calendar.firstWeekday
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents
    }
    
    fileprivate func configYearDates() -> [SVCalendarDate] {
        var beginYearDate = calendar.date(from: yearDateComponents(from: visibleDate,
                                                                   for: SVCalendarConfiguration.shared.minYear))
        
        let endYearDate = calendar.date(from: yearDateComponents(from: visibleDate,
                                                                 for: SVCalendarConfiguration.shared.maxYear + 1))
        
        var dates = [SVCalendarDate]()
        while beginYearDate!.compare(endYearDate!) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: beginYearDate!)
            let title = "\(calendarComponents.year!)"
            let isCurrent = calendarComponents.year! == currentComponents.year!
            
            dates.append(SVCalendarDate(isEnabled: true,
                                        isCurrent: isCurrent,
                                        isWeekend: false,
                                        title: title,
                                        value: beginYearDate!,
                                        type: .year))
            
            calendarComponents.year! += 1
            beginYearDate = calendar.date(from: calendarComponents)
        }
        
        return dates
    }
    
    // MARK: - Quarter Dates
    fileprivate func quarterDateComponents(from date: Date) -> DateComponents {
        var dateComponents = calendar.dateComponents(components, from: date)
        dateComponents.month = 1
        dateComponents.weekday = calendar.firstWeekday
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents
    }
    
    fileprivate func configQuarterDates() -> [SVCalendarDate] {
        var quarterDateComponents = self.quarterDateComponents(from: visibleDate)
        var beginQuarterDate = calendar.date(from: quarterDateComponents)
        
        quarterDateComponents.month = 13
        let endQuarterDate = calendar.date(from: quarterDateComponents)
        
        var dates = [SVCalendarDate]()
        while beginQuarterDate!.compare(endQuarterDate!) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: beginQuarterDate!)
            let title = "\(calendarComponents.quarter!)"
            let isCurrent = calendarComponents.quarter! == currentComponents.quarter!
            
            dates.append(SVCalendarDate(isEnabled: true,
                                        isCurrent: isCurrent,
                                        isWeekend: false,
                                        title: title,
                                        value: beginQuarterDate!,
                                        type: .quarter))
            
            calendarComponents.month! += 1
            beginQuarterDate = calendar.date(from: calendarComponents)
        }
        
        return dates
    }
    
    // MARK: - Months Dates
    fileprivate func monthBeginDate(from date: Date) -> Date {
        let sourceComponents = calendar.dateComponents(components, from: date)
        var dateComponents = DateComponents()
        dateComponents.year = sourceComponents.year
        dateComponents.month = sourceComponents.month
        dateComponents.weekday = calendar.firstWeekday
        dateComponents.day = 1
        
        return calendar.date(from: dateComponents)!
    }
    
    fileprivate func monthEndDate(from date: Date) -> Date {
        var sourceComponents = calendar.dateComponents(components, from: date)
        let daysInMonth = calendar.range(of: .day, in: .month, for: date)
        
        sourceComponents.day = daysInMonth!.count
        
        return calendar.date(from: sourceComponents)!
    }
    
    fileprivate func configMonthDates() -> [SVCalendarDate] {
        let beginMonthDate = monthBeginDate(from: visibleDate)
        let endMonthDate = monthEndDate(from: beginMonthDate)
        
        let daysInWeek = 7
        let weeksInMonth = calendar.range(of: .weekOfMonth, in: .month, for: beginMonthDate)
        
        let beginMonthComponents = calendar.dateComponents(components, from: beginMonthDate)
        var endMonthComponents = calendar.dateComponents(components, from: endMonthDate)
        
        var startDate: Date?
        var endDate: Date?
        
        if let weekDay = beginMonthComponents.weekday, indexOfDay(with: weekDay) <= daysInWeek {
            startDate = calendar.date(byAdding: .day, value: -indexOfDay(with: weekDay), to: beginMonthDate)
        }
        else {
            startDate = beginMonthDate
        }
        
        if let weekDay = endMonthComponents.weekday, indexOfDay(with: weekDay) != daysInWeek {
            let difference = daysInWeek - indexOfDay(with: weekDay)
            endDate = calendar.date(byAdding: .day, value: difference, to: endMonthDate)
        }
        else {
            endDate = endMonthDate
        }
        
        if weeksInMonth!.count < 6 {
            endDate = calendar.date(byAdding: .day, value: daysInWeek, to: endMonthDate)
            endMonthComponents = calendar.dateComponents(components, from: endDate!)
            
            if let weekDay = endMonthComponents.weekday, indexOfDay(with: weekDay) != daysInWeek {
                let difference = daysInWeek - indexOfDay(with: weekDay)
                endDate = calendar.date(byAdding: .day, value: difference, to: endDate!)
            }
        }
        
        guard startDate != nil && endDate != nil else {
            assert(false, " --- SVCalendarService - ConfigMonthDates - Month list is empty")
            return []
        }
        
        var dates = [SVCalendarDate]()
        while startDate!.compare(endDate!) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: startDate!)
            let title = "\(calendarComponents.day!)"
            let isEnabled = (startDate?.compare(beginMonthDate) == .orderedDescending || startDate?.compare(beginMonthDate) == .orderedSame) && (startDate?.compare(endMonthDate) == .orderedAscending || startDate?.compare(endMonthDate) == .orderedSame)
            let isCurrent = calendarComponents.day! == currentComponents.day!
            let isWeekend = calendarComponents.weekday! == SVCalendarWeekDays.sat.rawValue || calendarComponents.weekday! == SVCalendarWeekDays.sun.rawValue
            
            dates.append(SVCalendarDate(isEnabled: isEnabled,
                                        isCurrent: isCurrent,
                                        isWeekend: isWeekend,
                                        title: title,
                                        value: startDate!,
                                        type: .month))
            
            calendarComponents.day! += 1
            startDate = calendar.date(from: calendarComponents)            
        }
        
        return dates
    }
    
    // MARK: - Week Dates
    fileprivate func weekDateComponents(from date: Date) -> DateComponents {
        var dateComponents = calendar.dateComponents(components, from: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents
    }
    
    fileprivate func configWeekDates() -> [SVCalendarDate] {
        let dateComponents = weekDateComponents(from: visibleDate)
        let daysInWeek = 7
        
        let beginMonthDate = monthBeginDate(from: visibleDate)
        let endMonthDate = monthEndDate(from: beginMonthDate)
        
        var beginWeekDate: Date?
        var endWeekDate: Date?
        
        if dateComponents.weekday! != SVCalendarWeekDays.mon.rawValue {
            beginWeekDate = calendar.date(byAdding: .day, value: -indexOfDay(with: dateComponents.weekday!), to: calendar.date(from: dateComponents)!)
        }
        else {
            beginWeekDate = visibleDate
        }
        
        endWeekDate = calendar.date(byAdding: .day, value: daysInWeek, to: beginWeekDate!)
        
        guard beginWeekDate != nil && endWeekDate != nil else {
            assert(false, " --- SVCalendarService - ConfigWeekDates - Week list is empty")
            return []
        }
        
        var dates = [SVCalendarDate]()
        while beginWeekDate!.compare(endWeekDate!) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: beginWeekDate!)
            let title = "\(calendarComponents.day!)"
            let isEnabled = (beginWeekDate?.compare(beginMonthDate) == .orderedDescending || beginWeekDate?.compare(beginMonthDate) == .orderedSame) && (beginWeekDate?.compare(endMonthDate) == .orderedAscending || beginWeekDate?.compare(endMonthDate) == .orderedSame)
            let isCurrent = calendarComponents.day! == currentComponents.day!
            let isWeekend = calendarComponents.weekday! == SVCalendarWeekDays.sat.rawValue || calendarComponents.weekday! == SVCalendarWeekDays.sun.rawValue
            
            dates.append(SVCalendarDate(isEnabled: isEnabled,
                                        isCurrent: isCurrent,
                                        isWeekend: isWeekend,
                                        title: title,
                                        value: beginWeekDate!,
                                        type: .week))
            
            calendarComponents.day! += 1
            beginWeekDate = calendar.date(from: calendarComponents)
        }
        
        return dates
    }
    
    // MARK: - Day Dates
    fileprivate func indexOfDay(with day: Int) -> Int {
        switch day {
        case SVCalendarWeekDays.mon.rawValue:
            return 0
        
        case SVCalendarWeekDays.tue.rawValue:
            return 1
            
        case SVCalendarWeekDays.wed.rawValue:
            return 2
            
        case SVCalendarWeekDays.thu.rawValue:
            return 3
            
        case SVCalendarWeekDays.fri.rawValue:
            return 4
            
        case SVCalendarWeekDays.sat.rawValue:
            return 5
            
        case SVCalendarWeekDays.sun.rawValue:
            return 6
            
        default:
            return 0
        }
    }
    
    fileprivate func endDayDate(from date: Date) -> Date {
        var dateComponents = calendar.dateComponents(components, from: date)
        dateComponents.weekday = calendar.firstWeekday
        dateComponents.day! += 1
        dateComponents.hour = 1
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return calendar.date(from: dateComponents)!
    }
    
    fileprivate func configDayDates() -> [SVCalendarDate] {
        var beginDayDate = calendar.startOfDay(for: visibleDate)
        let endDayDate = self.endDayDate(from: beginDayDate)
        
        var dates = [SVCalendarDate]()
        while beginDayDate.compare(endDayDate) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: beginDayDate)
            let title = "\(calendarComponents.hour!)"
            let isEnabled = calendarComponents.hour! >= currentComponents.hour! || calendarComponents.day! > currentComponents.day!
            let isCurrent = calendarComponents.hour! == currentComponents.hour!
            let isWeekend = calendarComponents.weekday! == SVCalendarWeekDays.sat.rawValue || calendarComponents.weekday! == SVCalendarWeekDays.sun.rawValue
            
            dates.append(SVCalendarDate(isEnabled: isEnabled,
                                        isCurrent: isCurrent,
                                        isWeekend: isWeekend,
                                        title: title,
                                        value: beginDayDate,
                                        type: .day))
            
            calendarComponents.hour! += 1
            beginDayDate = calendar.date(from: calendarComponents)!            
        }
        
        return dates
    }
}

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

public struct SVCalendarDateFormat {
    static let short = "dd.MM.yyyy"
    static let full = "dd EEEE, MMMM yyyy"
    static let monthYear = "MMMM yyyy"
    static let dayMonthYear = "d MMM yyyy"
    static let time = "HH:mm"
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
    fileprivate let minYear: Int
    fileprivate let maxYear: Int
    
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
    fileprivate var calendarDates = [SVCalendarType : Array<[SVCalendarDate]>]()
    fileprivate var calendarTitles = [SVCalendarType : [String]]()
    
    var updatedDate: Date {
        return self.visibleDate
    }
    
    // MARK: - Calendar Brain LifeCycle
    init(types: [SVCalendarType], minYear: Int, maxYear: Int) {
        self.types = types
        self.minYear = minYear
        self.maxYear = maxYear
        self.visibleDate = currentDate
        
        self.configurate()
    }
    
    deinit {
        removeAllDates()
    }
    
    // MARK: - Calendar Methods
    func configurate() {
        self.removeAllDates()
        self.updateCalendarDates()
        self.updateCaledarTitles()
    }
    
    fileprivate func updateCalendarDates() {
        if self.types.contains(SVCalendarType.all) {
            self.calendarDates[.month] = self.configMonthDates()
            self.calendarDates[.week] = self.configWeekDates()
            self.calendarDates[.day] = self.configDayDates(nil)
            return
        }
        
        if self.types.contains(SVCalendarType.month) {
            self.calendarDates[.month] = self.configMonthDates()
        }
        
        if self.types.contains(SVCalendarType.week) {
            self.calendarDates[.week] = self.configWeekDates()
        }
        
        if self.types.contains(SVCalendarType.day) {
            self.calendarDates[.day] = self.configDayDates(nil)
        }
    }
    
    func updateCaledarTitles() {
        if self.types.contains(SVCalendarType.all) {
            self.calendarTitles[.month] = self.calendar.shortWeekdaySymbols
            self.calendarTitles[.week] = self.calendar.shortWeekdaySymbols
            self.calendarTitles[.day] = self.calendar.shortWeekdaySymbols
            return
        }
        
        if self.types.contains(SVCalendarType.month) {
            self.calendarTitles[.month] = self.calendar.shortWeekdaySymbols
        }
        
        if self.types.contains(SVCalendarType.week) {
            self.calendarTitles[.week] = self.calendar.shortWeekdaySymbols
        }
        
        if self.types.contains(SVCalendarType.day) {
            self.calendarTitles[.day] = self.calendar.shortWeekdaySymbols
        }
    }
    
    func updateDate(for calendarType: SVCalendarType, isDateIncrease: Bool) {
        var dateComponents = self.calendar.dateComponents(self.components, from: self.visibleDate)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        let sign = isDateIncrease ? 1 : -1
        
        switch calendarType {
        case SVCalendarType.day: dateComponents.day! += sign
        case SVCalendarType.week: dateComponents.day! += sign * 7
        case SVCalendarType.month: dateComponents.month! += sign
        default:
            break
        }
        
        self.visibleDate = calendar.date(from: dateComponents)!
        
        self.removeAllDates()
        self.updateCalendarDates()
        self.updateCaledarTitles()
    }
    
    func dates(for type: SVCalendarType) -> Array<[SVCalendarDate]> {
        guard let dates = self.calendarDates[type] else {
            return []
        }
        
        return dates
    }
    
    func titles(for type: SVCalendarType) -> [String] {
        guard let titles = self.calendarTitles[type] else {
            return []
        }
        
        return titles
    }
    
    func dateComponents(from date: Date) -> DateComponents {
        return calendar.dateComponents(components, from: date)
    }
    
    fileprivate func removeAllDates() {
        self.calendarDates.removeAll()
        self.calendarTitles.removeAll()
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
    
    fileprivate func configMonthDates() -> Array<[SVCalendarDate]> {
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
        
        return [dates]
    }
    
    // MARK: - Week Dates
    fileprivate func weekDateComponents(from date: Date) -> DateComponents {
        var dateComponents = calendar.dateComponents(components, from: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return dateComponents
    }
    
    fileprivate func configWeekDates() -> Array<[SVCalendarDate]> {
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
        
        var weekDates = [[SVCalendarDate]]()
        
        while beginWeekDate!.compare(endWeekDate!) != .orderedSame {
            var calendarComponents = calendar.dateComponents(components, from: beginWeekDate!)
            let isEnabled = (beginWeekDate?.compare(beginMonthDate) == .orderedDescending || beginWeekDate?.compare(beginMonthDate) == .orderedSame) && (beginWeekDate?.compare(endMonthDate) == .orderedAscending || beginWeekDate?.compare(endMonthDate) == .orderedSame)
            let isCurrent = calendarComponents.day! == currentComponents.day!
            let isWeekend = calendarComponents.weekday! == SVCalendarWeekDays.sat.rawValue || calendarComponents.weekday! == SVCalendarWeekDays.sun.rawValue
                        
            if let dayDates = self.configDayDates(beginWeekDate).first {
                for (index, value) in dayDates.enumerated() {
                    let date = SVCalendarDate(isEnabled: isEnabled,
                                              isCurrent: isCurrent,
                                              isWeekend: isWeekend,
                                              title: value.title,
                                              value: value.value,
                                              type: .week)
                    
                    if index > weekDates.count - 1 {                        
                        weekDates.append([date])
                    }
                    else {
                        weekDates[index].append(date)
                    }                                        
                }
            }
            
            calendarComponents.day! += 1
            beginWeekDate = calendar.date(from: calendarComponents)
        }
        
        return weekDates
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
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return calendar.date(from: dateComponents)!
    }
    
    fileprivate func configDayDates(_ sourceDate: Date?) -> Array<[SVCalendarDate]> {
        var beginDayDate = self.calendar.startOfDay(for: sourceDate ?? self.visibleDate)
        let endDayDate = self.endDayDate(from: beginDayDate)
        
        var dates = [SVCalendarDate]()
        while beginDayDate.compare(endDayDate) != .orderedDescending {
            var calendarComponents = self.calendar.dateComponents(components, from: beginDayDate)
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
            beginDayDate = self.calendar.date(from: calendarComponents)!
        }
        
        return [dates]
    }
}

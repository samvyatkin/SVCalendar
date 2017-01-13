//
//  SVCalendarViewController.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

public class SVCalendarViewController: UIViewController, SVCalendarSwitcherDelegate, SVCalendarNavigationDelegate {
    fileprivate let calendarView: SVCollectionView
    fileprivate let service: SVCalendarService
    
    fileprivate var switcherView: SVCalendarSwitcherView?
    fileprivate var navigationView: SVCalendarNavigationView!
    
    public let config: SVConfiguration
    public var identifier: String = SVCalendarViewDayCell.identifier
    
    public var dates = [SVCalendarDate]()
    public var headerTitles = [String]()
    
    public weak var delegate: SVCalendarDelegate?
    public var selectedDate: Date?
    
    public var type: SVCalendarType = SVCalendarType.day {
        didSet {
            switch type {
            case SVCalendarType.day: self.identifier = SVCalendarViewDayCell.identifier
            case SVCalendarType.week: self.identifier = ""
            case SVCalendarType.month: self.identifier = SVCalendarViewMonthCell.identifier
            case SVCalendarType.quarter: self.identifier = ""
            case SVCalendarType.year: self.identifier = ""
            default: break
            }
        }
    }

    // MARK: - Controller LifeCycle
    public init(config: SVConfiguration?) {
        self.config = config ?? SVConfiguration()
        self.calendarView = SVCollectionView(type: self.type,
                                             config: self.config.calendar)
        
        self.service = SVCalendarService(types: self.config.calendar.types,
                                         minYear: self.config.calendar.minYear,
                                         maxYear: self.config.calendar.maxYear)
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configAppearance()
    }

    override public func didReceiveMemoryWarning() {
        self.clearData()
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.clearData()
    }
    
    // MARK: - Configurate Appearance
    fileprivate func configAppearance() {
        self.configParentView()
        self.configCalendarSwitcher()
        self.configCalendarNavigation()
        self.configCalendarView()
        self.updateCalendarConstraints()
    }
    
    fileprivate func configParentView() {        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = self.config.container.style.background.normalColor
    }
    
    fileprivate func configCalendarView() {
        self.type = self.config.calendar.types.first ?? SVCalendarType.day
        self.calendarView.flowLayout.type = self.type
        
        self.view.addSubview(self.calendarView)
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        self.updateCalendarLayout(type: self.type)
        self.updateCalendarData(type: self.type)
    }
    
    fileprivate func configCalendarSwitcher() {
        if self.config.calendar.isSwitcherVisible {
            self.switcherView = SVCalendarSwitcherView(types: self.config.calendar.types,
                                                       style: self.config.switcher.style,
                                                       delegate: self)
            
            self.view.addSubview(self.switcherView!)
        }
    }
    
    fileprivate func configCalendarNavigation() {
        if self.config.calendar.isNavigationVisible {
            self.navigationView = SVCalendarNavigationView.navigation(delegate: self,
                                                                      style: self.config.navigation.style,
                                                                      title: self.service.updatedDate.convertWith(format: SVCalendarDateFormat.monthYear))            
            self.view.addSubview(self.navigationView)
            self.navigationView.updateNavigationDate(self.didChangeNavigationDate(direction: .none))
        }
    }
    
    fileprivate func updateCalendarConstraints() {
        var calendarViewTopConst: NSLayoutConstraint?
        var navigationViewTopConst: NSLayoutConstraint?
        
        var constraints = [
            NSLayoutConstraint.leadingConst(item: self.calendarView, toItem: self.view, value: 0.0),
            NSLayoutConstraint.trailingConst(item: self.calendarView, toItem: self.view, value: 0.0),
            NSLayoutConstraint.bottomConst(item: self.calendarView, toItem: self.view, value: 0.0)
        ]
        
        if self.config.calendar.isNavigationVisible {
            constraints += [
                NSLayoutConstraint.leadingConst(item: self.navigationView!, toItem: self.view, value: 5.0),
                NSLayoutConstraint.trailingConst(item: self.navigationView!, toItem: self.view, value: 5.0),
                NSLayoutConstraint.heightConst(item: self.navigationView!, value: 45.0)
            ]
            
            calendarViewTopConst = NSLayoutConstraint.topConstAfter(item: self.navigationView!,
                                                                    toItem: self.calendarView,
                                                                    value: 0)
            
            navigationViewTopConst = NSLayoutConstraint.topConst(item: self.navigationView!,
                                                                 toItem: self.view,
                                                                 value: 5.0)
        }
        
        if self.config.calendar.isSwitcherVisible {
            constraints += [
                NSLayoutConstraint.topConst(item: self.switcherView!, toItem: self.view, value: 5.0),
                NSLayoutConstraint.leadingConst(item: self.switcherView!, toItem: self.view, value: 5.0),
                NSLayoutConstraint.trailingConst(item: self.switcherView!, toItem: self.view, value: 5.0),
                NSLayoutConstraint.heightConst(item: self.switcherView!, value: 45.0)
            ]
            
            if calendarViewTopConst == nil {
                calendarViewTopConst = NSLayoutConstraint.topConstAfter(item: self.switcherView!,
                                                                        toItem: self.calendarView,
                                                                        value: 5.0)
            }
            else {
                navigationViewTopConst = NSLayoutConstraint.topConstAfter(item: self.switcherView!,
                                                                          toItem: self.navigationView!,
                                                                          value: 5.0)
            }
        }
        
        if calendarViewTopConst == nil {
            calendarViewTopConst = NSLayoutConstraint.topConst(item: self.calendarView,
                                                               toItem: self.view,
                                                               value: 0.0)
        }
        
        self.view.addConstraints(constraints)
        
        if calendarViewTopConst != nil {
            self.view.addConstraint(calendarViewTopConst!)
        }
        
        if navigationViewTopConst != nil {
            self.view.addConstraint(navigationViewTopConst!)
        }
    }
    
    // MARK: - Calendar Methods
    fileprivate func clearData() {
        dates.removeAll()
        headerTitles.removeAll()
    }
    
    fileprivate func updateCalendarData(type: SVCalendarType) {
        self.clearData()
        
        self.dates = service.dates(for: type)
        self.headerTitles = service.titles(for: type)
        
        self.calendarView.reloadData()
    }
    
    fileprivate func updateCalendarLayout(type: SVCalendarType) {
        self.calendarView.flowLayout.isHeader1Visible = self.config.calendar.isHeaderSection1Visible
        self.calendarView.flowLayout.isHeader2Visible = self.config.calendar.isHeaderSection2Visible        
        
        self.calendarView.flowLayout.type = type
    }
    
    // MARK: - Calendar Switcher
    public func didSelectType(_ type: SVCalendarType) {
        self.type = type
        
        self.updateCalendarLayout(type: type)
        self.updateCalendarData(type: type)
        
        if self.config.calendar.isNavigationVisible {
           self.navigationView.updateNavigationDate(self.didChangeNavigationDate(direction: .none))
        }
    }
    
    // MARK: - Calendar Navigation
    public func didChangeNavigationDate(direction: SVCalendarNavigationDirection) -> String? {
        if direction == .reduce {
            self.service.updateDate(for: self.type, isDateIncrease: false)
        }
        else if direction == .increase {
            self.service.updateDate(for: self.type, isDateIncrease: true)
        }
        
        var dateFormat = SVCalendarDateFormat.monthYear
        switch self.type {
        case SVCalendarType.day: dateFormat = SVCalendarDateFormat.dayMonthYear
        case SVCalendarType.week: break
        case SVCalendarType.month: break
        case SVCalendarType.quarter: break
        case SVCalendarType.year: break
        case SVCalendarType.all: break
        default: break
        }
        
        if direction != .none {
            self.updateCalendarData(type: self.type)
        }
        
        return self.service.updatedDate.convertWith(format: dateFormat)
    }
}

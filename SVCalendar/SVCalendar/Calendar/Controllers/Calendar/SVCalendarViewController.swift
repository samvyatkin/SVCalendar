//
//  SVCalendarViewController.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewController: UIViewController, SVCalendarSwitcherDelegate, SVCalendarNavigationDelegate {
    fileprivate lazy var calendarView = SVCollectionView()
        
    fileprivate let service = SVCalendarService(types: SVCalendarConfiguration.shared.types)
    fileprivate let config = SVCalendarConfiguration.shared
    
    fileprivate let style = SVCalendarConfiguration.shared.styles.container
    
    fileprivate var switcherView: SVCalendarSwitcherView?
    fileprivate var navigationView: SVCalendarNavigationView!
    
    var dates = [SVCalendarDate]()
    var headerTitles = [String]()
    
    weak var delegate: SVCalendarDelegate?
    var selectedDate: Date?

    // MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configAppearance()
    }

    override func didReceiveMemoryWarning() {
        clearData()
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        clearData()
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
        self.view.backgroundColor = style.background.normalColor
    }
    
    fileprivate func configCalendarView() {        
        self.view.addSubview(self.calendarView)
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        self.updateCalendarLayout(type: .month)
        self.updateCalendarData(type: .month)
    }
    
    fileprivate func configCalendarSwitcher() {
        if self.config.isSwitcherVisible {
            self.switcherView = SVCalendarSwitcherView(types: config.types,
                                                       delegate: self)
            
            self.view.addSubview(self.switcherView!)
        }
    }
    
    fileprivate func configCalendarNavigation() {
        if self.config.isNavigationVisible {
            self.navigationView = SVCalendarNavigationView.navigation(delegate: self,
                                                                      title: self.service.updatedDate.convertWith(format: SVCalendarDateFormat.monthYear))
            self.view.addSubview(self.navigationView)
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
        
        if self.config.isNavigationVisible {
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
        
        if self.config.isSwitcherVisible {
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
        self.calendarView.flowLayout.isAutoResizeCell = true
        
        self.calendarView.flowLayout.isHeader1Visible = self.config.isHeaderSection1Visible
        self.calendarView.flowLayout.isHeader2Visible = self.config.isHeaderSection2Visible
        self.calendarView.flowLayout.isTimeVisible = self.config.isTimeSectionVisible
        
        self.calendarView.flowLayout.cellPadding = 0.0
        self.calendarView.flowLayout.numberOfRows = 6
        self.calendarView.flowLayout.numberOfColumns = 7
        
        switch type {
        case SVCalendarType.day:
            break        
        case SVCalendarType.week:
            break
        case SVCalendarType.month:
            break
        case SVCalendarType.quarter:
            break
        case SVCalendarType.year:
            self.calendarView.flowLayout.isHeader1Visible = false
            self.calendarView.flowLayout.isHeader2Visible = false
            self.calendarView.flowLayout.isTimeVisible = false
            break
        case SVCalendarType.all:
            break
        default:
            break
        }
        
        self.calendarView.flowLayout.updateLayout()
    }
    
    // MARK: - Calendar Switcher
    func didSelectType(_ type: SVCalendarType) {
        self.updateCalendarLayout(type: type)
        self.updateCalendarData(type: type)
    }
    
    // MARK: - Calendar Navigation
    func didChangeNavigationDate(direction: SVCalendarNavigationDirection) -> String? {
        if direction == .reduce {
            self.service.updateDate(for: .month, isDateIncrease: false)
        }
        else if direction == .increase {
            self.service.updateDate(for: .month, isDateIncrease: true)
        }
        
        self.updateCalendarData(type: .month)
        
        return self.service.updatedDate.convertWith(format: SVCalendarDateFormat.monthYear)
    }
}

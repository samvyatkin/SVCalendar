//
//  ViewController.swift
//  DemoProject
//
//  Created by Sam on 08/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit
import SVCalendar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = SVConfiguration()
        config.calendar.isSwitcherVisible = true
        config.calendar.isNavigationVisible = true
        config.calendar.isHeaderSection1Visible = true
        
        let calendar = SVCalendarViewController(config: config)
        
        self.addChildViewController(calendar)
        self.view.addSubview(calendar.view)
        calendar.didMove(toParentViewController: self)
        
        var consts = [NSLayoutConstraint]()
        let bindingViews: [String: Any] = [
            "calendarView" : calendar.view
        ]
        
        consts += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[calendarView]-0-|", options: [], metrics: nil, views: bindingViews)
        consts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[calendarView]-0-|", options: [], metrics: nil, views: bindingViews)
        
        self.view.addConstraints(consts)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


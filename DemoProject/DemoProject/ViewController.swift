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
        // Show only month representation
        config.calendar.types = [SVCalendarType.month]
        
        // Switcher between day, week, month representations
        config.calendar.isSwitcherVisible = false
        config.calendar.isNavigationVisible = true
        config.calendar.isHeaderSection1Visible = true
        
        // Day, Week, Month navigation appearance
        config.switcher.style.text.normalColor = UIColor.lightGray
        config.switcher.style.text.selectedColor = UIColor.red
        
        // Calendar background appearance
        config.container.style.background.normalColor = UIColor.white
        
        // Cell appearance
        config.cell.style.text.normalColor = UIColor.darkGray
        config.cell.style.text.disabledColor = UIColor.lightGray
        config.cell.style.text.selectedColor = UIColor.red
        
        config.cell.style.selectionLayer.normalColor = UIColor.clear
        config.cell.style.selectionLayer.selectedColor = UIColor.red
        
        config.cell.style.bottomLineLayer.normalColor = UIColor.darkGray
        
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


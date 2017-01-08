//
//  SVCalendarManger.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 19/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation
import UIKit

/**
 Calendar Manager
 This class help easy set up calendar by default
 */

final public class SVCalendarManager {
    public class var calendarController: SVCalendarViewController {
        return SVCalendarViewController()
    }
    
    public class var bundleIdentifier: String {
        guard let bundle = Bundle(identifier: "SVCalendar") else {
            return "SVCalendar."
        }
        
        return "\(bundle.infoDictionary?[kCFBundleNameKey as String] as! String)."
    }
    
    public class func addCalendarTo(parentController: UIViewController, withConstraints constraints: [NSLayoutConstraint]?) -> SVCalendarViewController {
        let calendar = SVCalendarManager.calendarController
        
        parentController.addChildViewController(calendar)
        parentController.view.addSubview(calendar.view)
        calendar.didMove(toParentViewController: parentController)
        
        if constraints == nil {
            let bindingViews = [
                "calendarView": calendar.view
            ]
            
            var calendarConstraints = [NSLayoutConstraint]()
            calendarConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[calendarView]-0-|", options: [], metrics: nil, views: bindingViews)
            
            calendarConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[calendarView]-0-|", options: [], metrics: nil, views: bindingViews)
            
            parentController.view.addConstraints(calendarConstraints)
        }
        else {
            parentController.view.addConstraints(constraints!)
        }
        
        return calendar
    }
}

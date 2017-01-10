//
//  SVCalendarConstants.swift
//  SVCalendar
//
//  Created by Sam on 10/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import Foundation

final public class SVCalendarConstants {
    public static var bundle: Bundle? {
        return Bundle(for: self)
    }
    
    public static var bundleIdentifier: String {
        guard let bundle = SVCalendarConstants.bundle else {
            return "SVCalendar."
        }
        
        return "\(bundle.infoDictionary?[kCFBundleNameKey as String] as! String)."
    }
}

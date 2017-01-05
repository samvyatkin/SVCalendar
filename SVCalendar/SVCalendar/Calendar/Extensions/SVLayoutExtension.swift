//
//  SVLayoutExtension.swift
//  SVCalendarView
//
//  Created by Sam on 05/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    class func topConst(item: Any, toItem: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: value)
    }
    
    class func topConstAfter(item: Any, toItem: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: toItem, attribute: .top, relatedBy: .equal, toItem: item, attribute: .bottom, multiplier: 1.0, constant: value)
    }
    
    class func leadingConst(item: Any, toItem: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: 1.0, constant: value)
    }
    
    class func trailingConst(item: Any, toItem: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: toItem, attribute: .trailing, relatedBy: .equal, toItem: item, attribute: .trailing, multiplier: 1.0, constant: value)
    }
    
    class func bottomConst(item: Any, toItem: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: value)
    }
    
    class func heightConst(item: Any, value: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: value)
    }
}

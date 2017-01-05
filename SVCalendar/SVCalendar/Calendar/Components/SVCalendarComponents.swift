//
//  SVCalendarComponents.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 23/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation
import UIKit

enum SVCalendarTag: Int {
    case switcher = 100100
    case navigation = 100101
    case container = 100102
}

enum SVCalendarComponents {
    case defaultLabel(with: String)
    case defaultButton(with: String)
    case cellLabel(with: String)
    case switcherButton(with: String)
    
    func value() -> Any {
        switch self {
        case let .defaultLabel(title):
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.black
            label.text = title
            
            return label
            
        case let .defaultButton(title):
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.isExclusiveTouch = true
            
            return button            
            
        case let .cellLabel(title):
            let label = SVCalendarComponents.defaultLabel(with: title).value() as! UILabel            
            label.textAlignment = .center
            label.contentMode = .center
            
            return label
        
        case let .switcherButton(title):
            return SVCalendarSwitcherButton(withText: title)
        }
    }
}

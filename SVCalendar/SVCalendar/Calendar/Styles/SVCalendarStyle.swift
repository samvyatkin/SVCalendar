//
//  SVCalendarStyle.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation
import UIKit

/**
 Calendar's style
 This class contains values on which depends look of calendar view
 */

public enum SVCalendarControlls {
    case container, calendar, switcher, navigation, header1, header2, time, cell
}

struct SVCalendarStyle {
    struct Background {
        var normalColor: UIColor?
        var selectedColor: UIColor?
    }
    
    struct Button {
        var normalColor: UIColor?
        var selectedColor: UIColor?
        var radius: CGFloat = 0
    }
    
    struct Layer {
        var normalColor: UIColor?
        var selectedColor: UIColor?
        var radius: CGFloat = 0
    }
    
    struct Text {
        var font: UIFont?
        var normalColor: UIColor?
        var selectedColor: UIColor?
        var disabledColor: UIColor?
    }
    
    var background: Background
    var button: Button
    var layer: Layer
    var text: Text
    
    init(for control: SVCalendarControlls) {
        self.background = Background()
        self.button = Button()
        self.layer = Layer()
        self.text = Text()
        
        configStyleForController(control)
    }

    fileprivate mutating func configStyleForController(_ control: SVCalendarControlls) {
        switch control {
        case .container:
            background.normalColor = UIColor.rgb(23.0, 51.0, 88.0)
            break
            
        case .calendar:
            background.normalColor = UIColor.clear
            
            button.normalColor = UIColor.clear
            button.selectedColor = UIColor.red
            break
            
        case .navigation:
            background.normalColor = UIColor.rgb(23.0, 51.0, 88.0)
            
            text.font = UIFont.preferredFont(forTextStyle: .headline)
            text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
            break
            
        case .switcher:
            background.normalColor = UIColor.clear
            
            button.normalColor = UIColor.clear
            button.selectedColor = UIColor.rgb(117.0, 141.0, 177.0)
            
            layer.radius = 4.0
            
            text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
            text.selectedColor = UIColor.rgb(255.0, 255.0, 255.0)
            text.font = UIFont.preferredFont(forTextStyle: .headline)
            
            break
            
        case .header1:
            background.normalColor = UIColor.clear
            
            text.font = UIFont.preferredFont(forTextStyle: .caption1)
            text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
            
            break
            
        case .header2:
            background.normalColor = UIColor.clear
            break
            
        case .time:
            background.normalColor = UIColor.clear
            break
            
        case .cell:
            background.normalColor = UIColor.clear
            
            layer.normalColor = UIColor.clear
            layer.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
            
            text.font = UIFont.preferredFont(forTextStyle: .caption1)
            text.normalColor =  UIColor.rgb(221.0, 228.0, 237.0)
            text.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
            text.disabledColor = UIColor.rgb(142.0, 142.0, 142.0)
            
            break
        }
    }
}

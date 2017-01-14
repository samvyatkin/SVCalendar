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
 **Protocol describes visual appearance of component.**
 
 This protocol contains two properties which presented by structs:
    - SVBackground
    - SVText
 
 **SVBackground:**
    - normalColor: *Color in normal state (UIColor)*
    - selectedColor: *Color in selected state (UIColor)*
 
 **SVText:**
    - normalColor: *Color in normal state (UIColor)*
    - selectedColor: *Color in selected state (UIColor)*
    - disabledColor: *Color in disabled state (UIColor)*
    - font: *Radius of corners of button's layer (UIFont)*
    - aligment: *Text aligment in label (NSTextAligment)*
 
 */
public protocol SVStyleProtocol {
    var background: SVBackground { get set }
    var text: SVText { get set }
    
    init()
}

public struct SVBackground {
    var normalColor: UIColor
    var selectedColor: UIColor
    
    init() {
        self.normalColor = UIColor.white
        self.selectedColor = UIColor.white
    }
}

public struct SVText {
    var font: UIFont
    var normalColor: UIColor
    var selectedColor: UIColor
    var disabledColor: UIColor
    var aligment: NSTextAlignment
    
    init() {
        self.font = UIFont.preferredFont(forTextStyle: .headline)
        self.normalColor = UIColor.black
        self.selectedColor = UIColor.darkGray
        self.disabledColor = UIColor.lightGray
        self.aligment = NSTextAlignment.center
    }
}

/**
 
 */
public struct SVContainerStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.rgb(23.0, 51.0, 88.0)
    }
}

/**
 
 */
public struct SVCalendarStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.clear
    }
}

/**
 
 */
public struct SVSwitcherStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var button: SVBackground = SVBackground()
    public var text: SVText = SVText()
    public let radius: CGFloat = 4.0
    
    public init() {
        self.background.normalColor = UIColor.clear
        
        self.button.normalColor = UIColor.clear
        self.button.selectedColor = UIColor.rgb(117.0, 141.0, 177.0)
        
        self.text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
        self.text.selectedColor = UIColor.rgb(255.0, 255.0, 255.0)
        self.text.font = UIFont.preferredFont(forTextStyle: .headline)
    }
}

/**
 
 */
public struct SVNavigationStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.rgb(23.0, 51.0, 88.0)
        
        self.text.font = UIFont.preferredFont(forTextStyle: .headline)
        self.text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
    }
}

/**
 
 */
public struct SVHeader1Style: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.clear
        
        self.text.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.text.normalColor = UIColor.rgb(100.0, 121.0, 161.0)
    }
}

/**
 
 */
public struct SVHeader2Style: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.clear
    }
}

/**
 
 */
public struct SVTimeStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var layer: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.clear
        
        self.layer.normalColor = UIColor.clear
        self.layer.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
        
        self.text.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.text.normalColor =  UIColor.rgb(221.0, 228.0, 237.0)
    }
}

/**
 
 */
public struct SVCellStyle: SVStyleProtocol {
    public var background: SVBackground = SVBackground()
    public var borderLayer: SVBackground = SVBackground()
    public var bottomLineLayer: SVBackground = SVBackground()
    public var selectionLayer: SVBackground = SVBackground()
    public var text: SVText = SVText()
    
    public init() {
        self.background.normalColor = UIColor.clear
        
        self.borderLayer.normalColor = UIColor.clear
        self.borderLayer.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
        
        self.bottomLineLayer.normalColor = UIColor.clear
        self.bottomLineLayer.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
        
        self.selectionLayer.normalColor = UIColor.clear
        self.selectionLayer.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
        
        self.text.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.text.normalColor =  UIColor.rgb(221.0, 228.0, 237.0)
        self.text.selectedColor = UIColor.rgb(242.0, 245.0, 248.0)
        self.text.disabledColor = UIColor.rgb(142.0, 142.0, 142.0)
    }
}

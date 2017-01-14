//
//  SVCalendarSwitcherView.swift
//  SVCalendarView
//
//  Created by Sam on 20/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

protocol SVCalendarSwitcherDelegate: class {
    func didSelectType(_ type: SVCalendarType)
}

class SVCalendarSwitcherView: UIView {
    fileprivate lazy var stackViewContainer: UIStackView = {
        let control = UIStackView(frame: CGRect.zero)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.alignment = .fill
        control.axis = .horizontal
        control.spacing = 1.0
        control.distribution = .fillEqually
        
        return control
    }()
    
    fileprivate let types: [SVCalendarType]
    fileprivate let style: SVStyleProtocol
    fileprivate weak var delegate: SVCalendarSwitcherDelegate?
    
    var selectedIndex = 0
    
    // MARK: - Controller LifeCycle
    init(types: [SVCalendarType], style: SVStyleProtocol, delegate: SVCalendarSwitcherDelegate?) {
        self.types = types
        self.style = style
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
        
        self.configAppearance()
        self.configStackViewContainer()
        self.configStackViewContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurate Appearance
    fileprivate func configAppearance() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.style.background.normalColor
    }
    
    fileprivate func configStackViewContainer() {
        self.addSubview(self.stackViewContainer)
        self.bringSubview(toFront: self.stackViewContainer)
        
        let bindingViews: [String: Any] = [
            "stackViewContainer" : self.stackViewContainer
        ]
        
        let vertConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackViewContainer]-0-|", options: [], metrics: nil, views: bindingViews)
        let horizConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[stackViewContainer]-2-|", options: [], metrics: nil, views: bindingViews)
        
        self.addConstraints(vertConst)
        self.addConstraints(horizConst)
    }
    
    fileprivate func configStackViewContent() {
        var index = 0
        for type in self.types {
            var title = ""
            
            switch type {
            case SVCalendarType.day:
                title = "DAY"
                index = 0
            
            case SVCalendarType.week:
                title = "WEEK"
                index = 1
                
            case SVCalendarType.month:
                title = "MONTH"
                index = 2
                
            default:
                break
            }
            
            let switcher = SVCalendarComponents.switcherButton(style: self.style as! SVSwitcherStyle, with: title).value() as! SVCalendarSwitcherButton
            switcher.tag = index
            switcher.bottomLineDirection = SVCalendarSwitcherBottomLineDirection.right
            switcher.isSelected = index == 0
            switcher.addTarget(self, action: #selector(didChangeValue(_:)), for: .touchUpInside)
            
            self.stackViewContainer.addArrangedSubview(switcher)
        }
    }    
    
    // MARK: - Switcher Methods
    func didChangeValue(_ sender: SVCalendarSwitcherButton) {
        self.selectSwitcherButton(sender)
        
        var type: SVCalendarType
        switch sender.tag {
        case 0: type = .day                        
        case 1: type = .week
        case 2: type = .month
        default: type = .month
        }
        
        self.delegate?.didSelectType(type)
    }
    
    fileprivate func selectSwitcherButton(_ selectedButton: SVCalendarSwitcherButton) {
        let buttons = self.stackViewContainer.arrangedSubviews as! [SVCalendarSwitcherButton]
        
        var previousButton: SVCalendarSwitcherButton?
        var previousButtonIndex: Int?
        var selectedButtonIndex: Int?
        
        for (index, button) in buttons.enumerated() {
            if !button.isSelected && button.tag == selectedButton.tag {
                selectedButtonIndex = index
            }
            
            if button.isSelected {
                previousButton = button
                previousButtonIndex = index
            }
        }
        
        guard previousButtonIndex != nil && selectedButtonIndex != nil else {
            return
        }
        
        let direction = previousButtonIndex! >= selectedButtonIndex! ? SVCalendarSwitcherBottomLineDirection.left : .right
        
        previousButton?.bottomLineDirection = direction
        previousButton?.isSelected = false
        
        selectedButton.bottomLineDirection = direction
        selectedButton.isSelected = true
        
        self.selectedIndex = selectedButtonIndex!
    }
}

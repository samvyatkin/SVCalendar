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
    fileprivate let style = SVCalendarConfiguration.shared.styles.switcher
    fileprivate weak var delegate: SVCalendarSwitcherDelegate?
    
    var selectedIndex = 0
    
    // MARK: - Controller LifeCycle
    init(types: [SVCalendarType], delegate: SVCalendarSwitcherDelegate?) {
        self.types = types
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
        self.backgroundColor = style.background.normalColor
    }
    
    fileprivate func configStackViewContainer() {
        self.addSubview(stackViewContainer)
        self.bringSubview(toFront: stackViewContainer)
        
        let bindingViews = [
            "stackViewContainer" : stackViewContainer
        ]
        
        let vertConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackViewContainer]-0-|", options: [], metrics: nil, views: bindingViews)
        let horizConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[stackViewContainer]-2-|", options: [], metrics: nil, views: bindingViews)
        
        self.addConstraints(vertConst)
        self.addConstraints(horizConst)
    }
    
    fileprivate func configStackViewContent() {
        var index = 0
        for type in types {
            var title = ""
            
            switch type {
            case SVCalendarType.day:
                title = "DAY"
                index = 0
                break
            
            case SVCalendarType.week:
                title = "WEEK"
                index = 1
                break
                
            case SVCalendarType.month:
                title = "MONTH"
                index = 2
                break
                
            case SVCalendarType.quarter:
                title = "QUARTER"
                index = 3
                break
                
            case SVCalendarType.year:
                title = "YEAR"
                index = 4
                break
                
            default:
                break
            }
            
            let switcher = SVCalendarComponents.switcherButton(with: title).value() as! UIButton
            switcher.tag = index
            switcher.isSelected = index == 0
            switcher.addTarget(self, action: #selector(didChangeValue(_:)), for: .touchUpInside)
            
            stackViewContainer.addArrangedSubview(switcher)
        }
    }    
    
    // MARK: - Switcher Methods
    func didChangeValue(_ sender: UIButton) {
        selectSwitcherButton(sender)
        
        var type: SVCalendarType
        switch sender.tag {
        case 0:
            type = .day
            break
            
        case 1:
            type = .week
            break
            
        case 2:
            type = .month
            break
            
        case 3:
            type = .quarter
            break
            
        case 4:
            type = .year
            break
            
        default:
            type = .month
            break
        }
        
        delegate?.didSelectType(type)
    }
    
    fileprivate func selectSwitcherButton(_ selectedButton: UIButton) {
        for unselectedButton in stackViewContainer.arrangedSubviews as! [UIButton] {
            unselectedButton.isSelected = unselectedButton.tag == selectedButton.tag
        }
    }
}

//
//  SVCalendarSwitcherButton.swift
//  SVCalendarView
//
//  Created by Sam on 14/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarSwitcherButton: UIButton {
    fileprivate let style = SVCalendarConfiguration.shared.styles.switcher
    fileprivate let text: String
    
    // MARK: - Button LifeCycle
    override var isSelected: Bool {
        didSet {
            updateSelectionColor(isSelected)
        }
    }
    
    init(withText text: String) {
        self.text = text
        super.init(frame: CGRect.zero)
        
        configAppearance()
        configButtonData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config Appearance
    fileprivate func configAppearance() {
        self.titleLabel?.font = style.text.font
        
        self.setTitleColor(style.text.normalColor, for: .normal)
        self.setTitleColor(style.text.selectedColor, for: .selected)
        
        self.layer.isOpaque = true
        self.layer.cornerRadius = style.layer.radius
        self.layer.backgroundColor = style.button.normalColor?.cgColor
    }

    fileprivate func configButtonData() {
        self.setTitle(text, for: .normal)
    }
    
    // MARK: - Buttom Methods
    fileprivate func updateSelectionColor(_ isSelected: Bool) {
        self.layer.backgroundColor = isSelected ? style.button.selectedColor?.cgColor : style.button.normalColor?.cgColor
        self.layer.opacity = isSelected ? 0.8 : 1.0
    }
}

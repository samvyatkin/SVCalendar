//
//  SVCalendarSwitcherButton.swift
//  SVCalendarView
//
//  Created by Sam on 14/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarSwitcherButton: UIButton {
    fileprivate let style: SVSwitcherStyle
    fileprivate let text: String
    
    // MARK: - Button LifeCycle
    override var isSelected: Bool {
        didSet {
            self.updateSelectionColor(isSelected)
        }
    }
    
    init(style: SVSwitcherStyle, for text: String) {
        self.style = style
        self.text = text
        super.init(frame: CGRect.zero)
        
        self.configAppearance()
        self.configButtonData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config Appearance
    fileprivate func configAppearance() {
        self.titleLabel?.font = self.style.text.font

        self.setTitleColor(self.style.text.normalColor, for: .normal)
        self.setTitleColor(self.style.text.selectedColor, for: .selected)
        
        self.layer.isOpaque = true
        self.layer.cornerRadius = self.style.radius
        self.layer.backgroundColor = self.style.button.normalColor.cgColor
    }

    fileprivate func configButtonData() {
        self.setTitle(text, for: .normal)
    }
    
    // MARK: - Buttom Methods
    fileprivate func updateSelectionColor(_ isSelected: Bool) {
        self.layer.backgroundColor = isSelected ? self.style.button.selectedColor.cgColor : self.style.button.normalColor.cgColor
        self.layer.opacity = isSelected ? 0.8 : 1.0
    }
}

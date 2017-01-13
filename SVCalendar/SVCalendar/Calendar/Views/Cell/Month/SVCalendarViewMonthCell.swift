//
//  SVCalendarViewMonthCell.swift
//  SVCalendar
//
//  Created by Sam on 13/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewMonthCell: SVCalendarViewBaseCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    static var identifier: String {
        return NSStringFromClass(SVCalendarViewMonthCell.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
    
    override var style: SVCellStyle? {
        didSet {
            if self.valueLabel != nil {
                self.valueLabel.textColor = self.style?.text.normalColor
                self.valueLabel.font = self.style?.text.font
            }
            
            self.selectionLayer.fillColor = self.style?.layer.normalColor.cgColor
            self.selectionLayer.strokeColor = self.style?.layer.selectedColor.cgColor                        
        }
    }
    
    override var value: String? {
        didSet {
            if self.valueLabel != nil {
                self.valueLabel.text = value
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.valueLabel.textColor = isEnabled ?
                self.style?.text.normalColor :
                self.style?.text.disabledColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSelectionLayer(self.bounds)
    }
    
    override func configAppearance() {
        super.configAppearance()        
        self.contentView.layer.addSublayer(self.selectionLayer)
    }
}

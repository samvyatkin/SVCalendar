//
//  SVCalendarViewWeekCell.swift
//  SVCalendar
//
//  Created by Sam on 14/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewWeekCell: SVCalendarViewBaseCell {
    
    static var identifier: String {
        return NSStringFromClass(SVCalendarViewWeekCell.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
    
    override var style: SVCellStyle? {
        didSet {
            self.borderLayer.fillColor = self.style?.borderLayer.normalColor.cgColor
            self.borderLayer.strokeColor = self.style?.borderLayer.selectedColor.cgColor
            
            self.backgroundLayer.fillColor = UIColor.white.cgColor            
        }
    }
    
    override var isWeekend: Bool {
        didSet {
            self.backgroundLayer.isHidden = !isWeekend
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateBorderPath(self.bounds)
        self.updateBackgroundPath(self.bounds)
    }
    
    override func configAppearance() {
        super.configAppearance()        
        self.contentView.layer.addSublayer(self.borderLayer)
        self.contentView.layer.addSublayer(self.backgroundLayer)
    }
}

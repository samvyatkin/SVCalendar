//
//  SVCalendarViewDayCell.swift
//  SVCalendar
//
//  Created by Sam on 13/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewDayCell: SVCalendarViewBaseCell {

    static var identifier: String {
        return NSStringFromClass(SVCalendarViewDayCell.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
    
    override var style: SVCellStyle? {
        didSet {
            self.bottomLineLayer.fillColor = self.style?.bottomLineLayer.normalColor.cgColor
            self.bottomLineLayer.strokeColor = self.style?.bottomLineLayer.selectedColor.cgColor
        }
    }
    
    override var value: String? {
        didSet {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateBottomLinePath(self.bounds)
    }
    
    override func configAppearance() {
        super.configAppearance()
        self.contentView.layer.addSublayer(self.bottomLineLayer)
    }
}

//
//  SVCalendarTimeView.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 04/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarTimeView: UICollectionReusableView {
    @IBOutlet weak var valueLabel: UILabel!
    
    static var identifier: String {
        return NSStringFromClass(SVCalendarTimeView.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }        
    
    var style: SVTimeStyle? {
        didSet {
            if self.valueLabel != nil {
                self.valueLabel.textColor = self.style?.text.normalColor
                self.valueLabel.font = self.style?.text.font
            }
            
            self.backgroundColor = self.style?.background.normalColor
        }
    }
    
    var value: String? {
        didSet {
            if valueLabel != nil {
                valueLabel.text = value                
            }
        }
    }
    
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configAppearance()
    }
    
    // MARK: - View Appearance
    fileprivate func configAppearance() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizesSubviews = true
    }
}

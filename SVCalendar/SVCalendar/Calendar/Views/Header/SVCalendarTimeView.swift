//
//  SVCalendarTimeView.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 04/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarTimeView: UICollectionReusableView {
    static var identifier: String {
        return NSStringFromClass(SVCalendarTimeView.self).replacingOccurrences(of: SVCalendarManager.bundleIdentifier, with: "")
    }
    
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configAppearance()
    }
    
    // MARK: - View Appearance
    fileprivate func configAppearance() {
        self.backgroundColor = UIColor.purple
    }
}

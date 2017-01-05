//
//  SVCalendarHeaderView.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 04/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = style.text.font
            titleLabel.textColor = style.text.normalColor
        }
    }
    
    static var identifier: String {        
        return NSStringFromClass(SVCalendarHeaderView.self).replacingOccurrences(of: SVCalendarManager.bundleIdentifier, with: "")
    }
    
    fileprivate let style = SVCalendarConfiguration.shared.styles.header1
    
    var title: String? {
        didSet {
            if titleLabel != nil {
                titleLabel.text = title
            }
        }
    }
    
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configAppearance()
    }
    
    // MARK: - View Appearance
    fileprivate func configAppearance() {
        self.backgroundColor = style.background.normalColor
    }
}

//
//  SVCollectionView.swift
//  SVCalendarView
//
//  Created by Sam on 05/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCollectionView: UICollectionView {
    fileprivate let calendarLayout = SVCalendarFlowLayout(direction: SVCalendarFlowLayoutDirection.vertical)
    fileprivate let calendarStyle = SVCalendarConfiguration.shared.styles.calendar
    fileprivate let config = SVCalendarConfiguration.shared
    
    var flowLayout: SVCalendarFlowLayout {
        return self.calendarLayout
    }
    
    // MARK: - View LifeCycle
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: self.calendarLayout)                
        self.configAppearance()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.dataSource = nil
        self.delegate = nil
    }
    
    // MARK: - View Appearance
    fileprivate func configAppearance() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = calendarStyle.background.normalColor
        
        self.register(UINib(nibName: SVCalendarViewBaseCell.identifier, bundle: Bundle.main),
                      forCellWithReuseIdentifier: SVCalendarViewBaseCell.identifier)
        
        if self.config.isHeaderSection1Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: Bundle.main),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection1,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
        
        if self.config.isHeaderSection2Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: Bundle.main),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection2,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
        
        if self.config.isTimeSectionVisible {
            self.register(UINib(nibName: SVCalendarTimeView.identifier, bundle: Bundle.main),
                          forSupplementaryViewOfKind: SVCalendarTimeSection,
                          withReuseIdentifier: SVCalendarTimeView.identifier)
        }
    }
}

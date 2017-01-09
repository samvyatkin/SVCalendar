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
    fileprivate let calendarConfig: SVCalendarConfiguration
    
    var flowLayout: SVCalendarFlowLayout {
        return self.calendarLayout
    }
    
    // MARK: - View LifeCycle
    init(config: SVCalendarConfiguration) {
        self.calendarConfig = config
        
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
        self.backgroundColor = self.calendarConfig.style.background.normalColor
        
        self.register(UINib(nibName: SVCalendarViewBaseCell.identifier, bundle: SVCalendarManager.bundle!),
                      forCellWithReuseIdentifier: SVCalendarViewBaseCell.identifier)
        
        if self.calendarConfig.isHeaderSection1Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: SVCalendarManager.bundle!),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection1,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
        
        if self.calendarConfig.isHeaderSection2Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: SVCalendarManager.bundle!),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection2,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
        
        if self.calendarConfig.isTimeSectionVisible {
            self.register(UINib(nibName: SVCalendarTimeView.identifier, bundle: SVCalendarManager.bundle!),
                          forSupplementaryViewOfKind: SVCalendarTimeSection,
                          withReuseIdentifier: SVCalendarTimeView.identifier)
        }
    }
}

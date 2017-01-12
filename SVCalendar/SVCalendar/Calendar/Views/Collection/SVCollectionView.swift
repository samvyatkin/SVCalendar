//
//  SVCollectionView.swift
//  SVCalendarView
//
//  Created by Sam on 05/01/2017.
//  Copyright © 2017 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCollectionView: UICollectionView {
    fileprivate let calendarLayout: SVCalendarFlowLayout
    fileprivate let calendarConfig: SVCalendarConfiguration
    
    var flowLayout: SVCalendarFlowLayout {
        return self.calendarLayout
    }
    
    var type: SVCalendarType {
        didSet {
            
        }
    }
    
    // MARK: - View LifeCycle
    init(type: SVCalendarType, config: SVCalendarConfiguration) {
        self.type = type
        self.calendarConfig = config
        self.calendarLayout = SVCalendarFlowLayout(type: type, direction: SVCalendarFlowLayoutDirection.vertical)
        
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
        
        self.register(UINib(nibName: SVCalendarViewBaseCell.identifier, bundle: SVCalendarConstants.bundle!),
                      forCellWithReuseIdentifier: SVCalendarViewBaseCell.identifier)
        
        self.register(UINib(nibName: SVCalendarTimeView.identifier, bundle: SVCalendarConstants.bundle!),
                      forSupplementaryViewOfKind: SVCalendarTimeSection,
                      withReuseIdentifier: SVCalendarTimeView.identifier)
        
        if self.calendarConfig.isHeaderSection1Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: SVCalendarConstants.bundle!),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection1,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
        
        if self.calendarConfig.isHeaderSection2Visible {
            self.register(UINib(nibName: SVCalendarHeaderView.identifier, bundle: SVCalendarConstants.bundle!),
                          forSupplementaryViewOfKind: SVCalendarHeaderSection2,
                          withReuseIdentifier: SVCalendarHeaderView.identifier)
        }
    }
}

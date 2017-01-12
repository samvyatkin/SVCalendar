//
//  SVCalendarViewControllerExtension.swift
//  SVCalendarView
//
//  Created by Sam on 17/12/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import Foundation
import UIKit

extension SVCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Collection DataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case SVCalendarHeaderSection1:
            let index = indexPath.item + 1
            var title: String?
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: SVCalendarHeaderView.identifier,
                                                                             for: indexPath) as! SVCalendarHeaderView
            if headerTitles.count == 0 {
                title = "-"
            }
            else if index >= headerTitles.count {
                title = headerTitles[0]
            }
            else {
                title = headerTitles[index]
            }
            
            headerView.title = title
            headerView.style = self.config.header1.style
            
            return headerView
            
        case SVCalendarHeaderSection2:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: SVCalendarHeaderView.identifier,
                                                                             for: indexPath) as! SVCalendarHeaderView
            
            headerView.style = self.config.header1.style
            
            return headerView
            
        case SVCalendarTimeSection:
            let timeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: SVCalendarTimeView.identifier,
                                                                           for: indexPath) as! SVCalendarTimeView
                        
            return timeView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! SVCalendarViewBaseCell
        let model = self.dates[indexPath.item]
        
        cell.style = self.config.cell.style
        cell.value = model.title
        cell.isEnabled = model.isEnabled
        cell.isSelected = !(self.selectedDate == nil
            || self.selectedDate!.compare(model.value) != .orderedSame)
        
        return cell
    }
    
    // MARK: - Collection Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! SVCalendarViewBaseCell
        let model = dates[indexPath.item]
        
        cell.isSelected = true
        
        if self.selectedDate != nil {
            if let index = dates.index(where: { $0.value.compare(self.selectedDate!) == .orderedSame }) {
                let selectedIndex = IndexPath(item: index, section: 0)
                let selectedCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier,
                                                                      for: selectedIndex) as! SVCalendarViewBaseCell
                selectedCell.isSelected = false
            }
        }
        
        self.selectedDate = model.value
        self.delegate?.didSelectDate(model.value)
    }
}

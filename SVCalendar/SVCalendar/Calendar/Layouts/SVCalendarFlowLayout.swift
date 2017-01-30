//
//  SVCalendarFlowLayout.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

public let SVCalendarHeaderSection1 = "CalendarHeaderSection1"
public let SVCalendarHeaderSection2 = "CalendarHeaderSection2"
public let SVCalendarTimeSection = "CalendarTimeSection"

enum SVCalendarFlowLayoutDirection {
    case vertical, horizontal
}

class SVCalendarFlowLayout: UICollectionViewFlowLayout {
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right) - self.timeWidth
    }
    
    fileprivate var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.height - (insets.top + insets.bottom) - self.headerHeight
    }
    
    fileprivate let direction: SVCalendarFlowLayoutDirection!
    fileprivate var cache =  [IndexPath : UICollectionViewLayoutAttributes]()
    
    fileprivate var width: CGFloat = 0.0
    fileprivate var height: CGFloat = 0.0
    
    var isAutoResizeCell = false
    var isHeader1Visible = false
    var isHeader2Visible = false
    var isTimeVisible = false
    
    var numberOfColumns: Int?
    var numberOfRows: Int?
        
    var headerWidth: CGFloat = 0.0
    var headerHeight: CGFloat = 0.0
    
    var timeWidth: CGFloat = 0.0
    var timeHeight: CGFloat = 0.0
    
    var columnWidth: CGFloat = 50.0
    var columnHeight: CGFloat = 50.0
    var columnOffset: CGFloat = 0.0
    var cellPadding: CGFloat = 5.0
    
    var type: SVCalendarType {
        didSet {
            self.updateLayout()
        }
    }
    
    // MARK: - FlowLayout LifeCycle
    init(type: SVCalendarType, direction: SVCalendarFlowLayoutDirection) {
        self.type = type
        self.direction = direction
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cache.removeAll()
    }
    
    override func prepare() {
        if self.cache.isEmpty {
            var index = 0
            var xOffset = [CGFloat]()
            var yOffset = [CGFloat]()
            var columnContent: CGFloat = 0.0
            
            if self.direction == .vertical {
                self.width = self.contentWidth
                
                if self.numberOfColumns == nil {
                    self.numberOfColumns = Int(self.width/self.columnWidth)
                }
                
                if self.isHeader1Visible {
                    self.headerWidth = self.contentWidth / CGFloat(self.numberOfColumns!)
                    self.headerHeight = 45.0
                }
                
                if self.isHeader2Visible {
                    // TODO: Calculate secondary header
                }
                
                if self.isTimeVisible {
                    self.timeWidth = 65.0
                    self.timeHeight = self.columnHeight
                }
                
                if self.numberOfColumns == 1 {
                    if self.isAutoResizeCell {
                        self.columnWidth = self.contentWidth
                        
                        columnContent = CGFloat(numberOfColumns!) * (columnWidth - 2 * cellPadding)
                        columnOffset = contentWidth - columnContent
                    }
                }
                else {
                    if self.isAutoResizeCell {
                        self.columnWidth = (self.contentWidth - CGFloat(self.numberOfColumns! - 1) * self.cellPadding) / CGFloat(self.numberOfColumns!)
                        
                        if self.columnHeight == 0 {
                            self.columnHeight = self.columnWidth
                            
                            if self.numberOfRows != nil {
                                self.columnHeight = self.contentHeight / CGFloat(self.numberOfRows!)
                            }
                        }
                    }
                    
                    columnContent = CGFloat(self.numberOfColumns!) * (self.columnWidth - 2 * self.cellPadding)
                    columnOffset = (self.contentWidth - columnContent) / CGFloat(self.numberOfColumns! - 1)
                }
                
                for column in 0 ..< numberOfColumns! {
                    xOffset += [self.columnWidth * CGFloat(column) + self.columnOffset + self.timeWidth]
                    yOffset += [self.headerHeight]
                }
            }
            else {
                height = contentHeight
                columnHeight = contentHeight
                
                xOffset += [0]
                yOffset += [0]
            }
            
            let itemWidth = columnWidth - 2 * cellPadding
            let itemHeight = columnHeight - 2 * cellPadding
            
            for section in 0 ..< collectionView!.numberOfSections {
                for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    if direction == .vertical {
                        attributes.frame = CGRect(x: xOffset[index], y: yOffset[index], width: itemWidth, height: itemHeight)
                        height = max(height, attributes.frame.origin.y + itemHeight)
                        yOffset[index] = yOffset[index] + itemHeight
                        
                        if index >= numberOfColumns! - 1 {
                            index = 0
                        }
                        else {
                            index += 1
                        }
                    }
                    else {
                        attributes.frame = CGRect(x: xOffset[item], y: yOffset[0], width: itemWidth, height: itemHeight)
                        width = max(width, attributes.frame.origin.x + itemWidth)
                        xOffset += [xOffset[index] + itemWidth + timeWidth + 5.0]
                        index += 1
                    }
                    
                    cache[indexPath] = attributes
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard !self.collectionView!.bounds.equalTo(newBounds) else {
           return false
        }
        
        self.updateLayout()
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        for attr in cache {
            guard attr.value.frame.intersects(rect) else {
                continue
            }
            
            attrs.append(attr.value)
        }
        
        if self.isHeader1Visible {
            let indexPaths = headerView1Paths()
            for indexPath in indexPaths {
                guard let attr = self.layoutAttributesForSupplementaryView(ofKind: SVCalendarHeaderSection1, at: indexPath) else {
                    continue
                }
                
                attrs.append(attr)
            }
        }
        
        if self.isHeader2Visible {
            var index = -1
            
            if self.isHeader1Visible {
                index = self.headerView1Paths().count
            }
            
            let indexPaths = self.headerView2Paths(startIndex: index)
            for indexPath in indexPaths {
                guard let attr = self.layoutAttributesForSupplementaryView(ofKind: SVCalendarHeaderSection2, at: indexPath) else {
                    continue
                }
                
                attrs.append(attr)
            }
        }
        
        if self.isTimeVisible {
            let indexPaths = self.timeViewPaths()
            for indexPath in indexPaths {
                guard let attr = self.layoutAttributesForSupplementaryView(ofKind: SVCalendarTimeSection, at: indexPath) else {
                    continue
                }
                
                guard attr.frame.intersects(rect) else {
                    continue
                }
                
                attrs.append(attr)
            }
        }
        
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)        
        
        switch elementKind {
        case SVCalendarHeaderSection1:
            attrs.frame = CGRect(x: CGFloat(indexPath.item) * self.headerWidth, y: self.collectionView!.contentOffset.y, width: self.headerWidth, height: self.headerHeight)
            
            if self.isTimeVisible {
                self.headerWidth = self.contentWidth / CGFloat(self.numberOfColumns ?? 1)
                attrs.frame = CGRect(x: CGFloat(indexPath.item) * self.headerWidth + self.timeWidth , y: self.collectionView!.contentOffset.y, width: self.headerWidth, height: self.headerHeight)
            }
            
            attrs.zIndex = 1024
            break
            
        case SVCalendarHeaderSection2:
            attrs.frame = CGRect(x: 0.0, y: self.collectionView!.contentOffset.y + self.headerHeight, width: self.collectionView!.bounds.width, height: self.headerHeight)
            attrs.zIndex = 1023
            break
            
        case SVCalendarTimeSection:
            attrs.frame = CGRect(x: 0.0, y: CGFloat(indexPath.item) * self.timeHeight + self.headerHeight, width: self.timeWidth, height: self.timeHeight)
            attrs.zIndex = 1022            
            break
            
        default:
            break
        }
        
        return attrs
    }
    
    // MARK: - Layout Methods
    fileprivate func updateLayout() {
        self.width = 0.0
        self.height = 0.0
        
        self.isAutoResizeCell = true
        self.isTimeVisible = false
        self.cellPadding = 0.0
        
        self.headerHeight = 0.0
        self.headerWidth = 0.0
        
        self.timeWidth = 0.0
        self.timeHeight = 0.0
        
        self.columnWidth = 0.0
        self.columnHeight = 0.0
        
        self.numberOfRows = 6
        self.numberOfColumns = 7
        
        switch self.type {
        case SVCalendarType.day:
            self.isTimeVisible = true
            self.isHeader1Visible = false
            
            self.numberOfRows = 24
            self.numberOfColumns = 1
            
            self.columnHeight = 50
            
        case SVCalendarType.week:
            self.isTimeVisible = true
            
            self.numberOfRows = 24
            self.numberOfColumns = 7
            
            self.columnHeight = 50
            
        case SVCalendarType.month: break
        case SVCalendarType.all: break
        default: break
        }
        
        self.cache.removeAll()
        self.invalidateLayout()
    }
    
    fileprivate func headerView1Paths() -> [IndexPath] {
        guard self.numberOfColumns != nil else {
            return []
        }
        
        var indexPaths = [IndexPath]()
        for i in 0 ..< self.numberOfColumns! {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        
        return indexPaths
    }
    
    fileprivate func headerView2Paths(startIndex: Int) -> [IndexPath] {
        guard self.numberOfColumns != nil else {
            return []
        }
        
        var indexPaths = [IndexPath]()
        for i in 0 ..< self.numberOfColumns! {
            indexPaths.append(IndexPath(item: startIndex + i, section: 0))
        }
        
        return indexPaths
    }
    
    fileprivate func timeViewPaths() -> [IndexPath] {
        guard self.numberOfRows != nil else {
            return []
        }
        
        var indexPaths = [IndexPath]()
        for i in 0 ... self.numberOfRows! {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        return indexPaths
    }
}

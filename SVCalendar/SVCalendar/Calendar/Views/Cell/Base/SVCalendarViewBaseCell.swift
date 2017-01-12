//
//  SVCalendarViewBaseCell.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewBaseCell: UICollectionViewCell {
    
    lazy var selectionLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    override var bounds: CGRect {
        didSet {
            self.contentView.frame = self.bounds
        }
    }

    override var isSelected: Bool {
        didSet {
            self.selectionLayer.isHidden = !isSelected
        }
    }
    
    var style: SVCellStyle? {
        didSet {
            self.backgroundColor = self.style?.background.normalColor
            
            self.selectionLayer.fillColor = self.style?.layer.normalColor.cgColor
            self.selectionLayer.strokeColor = self.style?.layer.selectedColor.cgColor
        }
    }
    var value: String? 
    var isEnabled: Bool = true
    
    // MARK: - Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selectionWidth = min(self.bounds.size.width, self.bounds.size.height) * 0.75
        let selectionX = (self.bounds.size.width - selectionWidth) * 0.5
        let selectionY = (self.bounds.size.height - selectionWidth) * 0.5
        let selectionRect = CGRect(x: selectionX, y: selectionY, width: selectionWidth, height: selectionWidth)
        
        self.selectionLayer.frame = self.bounds
        self.selectionLayer.path = UIBezierPath(roundedRect: selectionRect, cornerRadius: selectionRect.size.width * 0.5).cgPath
    }
    
    // MARK: - Configurate Appearance
    fileprivate func configAppearance() {
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.autoresizesSubviews = true
        
        self.contentView.layer.addSublayer(self.selectionLayer)
    }
}

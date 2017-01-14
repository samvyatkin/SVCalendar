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
    
    lazy var borderPath = UIBezierPath()
    lazy var borderLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    lazy var bottomLinePath = UIBezierPath()
    lazy var bottomLineLayer: CAShapeLayer = {
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
        }
    }
    var value: String? 
    var isEnabled: Bool = true
    
    // MARK: - Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configAppearance()
    }
    
    // MARK: - Configurate Appearance
    func configAppearance() {
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.autoresizesSubviews = true                
    }
    
    // MARK: - BottomLine Layer
    func configBottomLineLayer() {
        self.bottomLineLayer.opacity = 1.0
        self.bottomLineLayer.isOpaque = true
        
        self.bottomLineLayer.lineJoin = kCALineJoinMiter
        self.bottomLineLayer.lineWidth = 0.5
        
        self.layer.addSublayer(self.bottomLineLayer)
    }
    
    func updateBottomLinePath(_ bounds: CGRect) {
        self.bottomLinePath.move(to: CGPoint(x: bounds.origin.x + 6.5, y: bounds.size.height))
        self.bottomLinePath.addLine(to: CGPoint(x: bounds.size.width - 6.5, y: bounds.size.height))
        self.bottomLinePath.close()
        
        self.bottomLineLayer.path = self.bottomLinePath.cgPath
    }
    
    // MARK: - Border Layer
    func configBorderLayer() {
        self.borderLayer.opacity = 1.0
        self.borderLayer.isOpaque = true
        
        self.borderLayer.lineJoin = kCALineJoinMiter
        self.borderLayer.lineWidth = 0.5
        
        self.layer.addSublayer(self.borderLayer)
    }
    
    func updateBorderPath(_ bounds: CGRect) {
        self.borderPath.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y))
        self.borderPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.origin.y))
        self.borderPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        self.borderPath.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.size.height))        
        self.borderPath.close()
        
        self.borderLayer.path = self.borderPath.cgPath
    }
    
    // MARK: - Selection Layer
    func updateSelectionLayer(_ bounds: CGRect) {
        let selectionWidth = min(bounds.size.width, bounds.size.height) * 0.75
        let selectionX = (bounds.size.width - selectionWidth) * 0.5
        let selectionY = (bounds.size.height - selectionWidth) * 0.5
        let selectionRect = CGRect(x: selectionX, y: selectionY, width: selectionWidth, height: selectionWidth)
        
        self.selectionLayer.frame = bounds
        self.selectionLayer.path = UIBezierPath(roundedRect: selectionRect, cornerRadius: selectionRect.size.width * 0.5).cgPath
    }
}

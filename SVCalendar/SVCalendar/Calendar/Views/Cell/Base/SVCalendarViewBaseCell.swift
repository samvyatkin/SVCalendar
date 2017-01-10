//
//  SVCalendarViewBaseCell.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewBaseCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    static var identifier: String {
        return NSStringFromClass(SVCalendarViewBaseCell.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
    
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
            
            if self.valueLabel != nil {
                self.valueLabel.textColor = self.style?.text.normalColor
                self.valueLabel.font = self.style?.text.font
            }
        }
    }
    var value: String? {
        didSet {
            if self.valueLabel != nil {
                self.valueLabel.text = value
            }
        }
    }
    var isEnabled: Bool = true {
        didSet {
            self.valueLabel.textColor = isEnabled ?
                self.style?.text.normalColor :
                self.style?.text.disabledColor
        }
    }
    
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

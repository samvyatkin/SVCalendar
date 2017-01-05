//
//  SVCalendarViewBaseCell.swift
//  SVCalendarView
//
//  Created by Semyon Vyatkin on 18/10/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

class SVCalendarViewBaseCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel! {
        didSet {
            valueLabel.textColor = SVCalendarViewBaseCell.style.text.normalColor
            valueLabel.font = SVCalendarViewBaseCell.style.text.font
        }
    }
    
    static let style = SVCalendarConfiguration.shared.styles.cell
    static var identifier: String {
        return NSStringFromClass(SVCalendarViewBaseCell.self).replacingOccurrences(of: SVCalendarManager.bundleIdentifier, with: "")
    }
    
    lazy var selectionLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = SVCalendarViewBaseCell.style.layer.normalColor?.cgColor
        circleLayer.strokeColor = SVCalendarViewBaseCell.style.layer.selectedColor?.cgColor
        
        return circleLayer
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
                SVCalendarViewBaseCell.style.text.normalColor :
                SVCalendarViewBaseCell.style.text.disabledColor
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
        self.layer.backgroundColor = SVCalendarViewBaseCell.style.button.normalColor?.cgColor
            
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.autoresizesSubviews = true
        
        self.contentView.layer.addSublayer(self.selectionLayer)
    }
}

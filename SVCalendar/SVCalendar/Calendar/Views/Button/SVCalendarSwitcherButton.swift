//
//  SVCalendarSwitcherButton.swift
//  SVCalendarView
//
//  Created by Sam on 14/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

enum SVCalendarSwitcherBottomLineDirection {
    case left, right
}

class SVCalendarSwitcherButton: UIButton {
    fileprivate let style: SVSwitcherStyle
    fileprivate let text: String
    
    fileprivate var bottomLinePath = UIBezierPath()
    fileprivate var bottomLineLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    // MARK: - Button LifeCycle
    var bottomLineDirection: SVCalendarSwitcherBottomLineDirection = .right
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                self.updateBottomLineLayerVisibility(isSelected)
            }
        }
    }
    
    init(style: SVSwitcherStyle, for text: String) {
        self.style = style
        self.text = text
        super.init(frame: CGRect.zero)
        
        self.configAppearance()
        self.configBottomLineLayer()
        self.configButtonData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateBottomLinePath(self.bounds)
    }
    
    // MARK: - Config Appearance
    fileprivate func configAppearance() {
        self.titleLabel?.font = self.style.text.font

        self.setTitleColor(self.style.text.normalColor, for: .normal)
        self.setTitleColor(self.style.text.selectedColor, for: .selected)
        
        self.layer.isOpaque = true
        self.layer.cornerRadius = self.style.radius
        self.layer.backgroundColor = self.style.button.normalColor.cgColor
    }

    fileprivate func configButtonData() {
        self.setTitle(text, for: .normal)
    }
    
    fileprivate func configBottomLineLayer() {
        self.bottomLineLayer.opacity = 0.0
        self.bottomLineLayer.isOpaque = true
        
        self.bottomLineLayer.strokeColor = UIColor.red.cgColor
        self.bottomLineLayer.fillColor = UIColor.clear.cgColor
        self.bottomLineLayer.fillRule = kCAFillRuleNonZero

        self.bottomLineLayer.lineJoin = kCALineJoinRound
        self.bottomLineLayer.lineWidth = 1.75
        
        self.bottomLineLayer.shadowColor = UIColor.white.cgColor
        self.bottomLineLayer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        self.bottomLineLayer.shadowRadius = 2.0
        self.bottomLineLayer.shadowOpacity = 0.2
        
        self.layer.addSublayer(self.bottomLineLayer)
    }
    
    fileprivate func updateBottomLinePath(_ bounds: CGRect) {
        self.bottomLinePath.move(to: CGPoint(x: bounds.origin.x + 6.5, y: bounds.size.height - 2.0))
        self.bottomLinePath.addLine(to: CGPoint(x: bounds.size.width - 6.5, y: bounds.size.height - 2.0))
        self.bottomLinePath.close()
        
        self.bottomLineLayer.path = self.bottomLinePath.cgPath
    }
    
    fileprivate func updateBottomLineLayerVisibility(_ isSelected: Bool) {
        let animationKey = "SVCalendarCABasicAnimation"
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        
        let x = self.bottomLineLayer.position.x
        let y = self.bottomLineLayer.position.y
        
        if isSelected {
            if self.bottomLineDirection == .left {
                positionAnimation.fromValue = CGPoint(x: self.bounds.size.width, y: y)
                positionAnimation.toValue = CGPoint(x: x, y: y)                
            }
            else {
                positionAnimation.fromValue = CGPoint(x: -self.bounds.size.width, y: y)
                positionAnimation.toValue = CGPoint(x: x, y: y)
            }
            
            fadeAnimation.fromValue = 0.0
            fadeAnimation.toValue = 1.0
        }
        else {
            if self.bottomLineDirection == .left {
                positionAnimation.fromValue = CGPoint(x: x, y: y)
                positionAnimation.toValue = CGPoint(x: -self.bounds.size.width, y: y)
            }
            else {
                positionAnimation.fromValue = CGPoint(x: x, y: y)
                positionAnimation.toValue = CGPoint(x: self.bounds.size.width, y: y)
            }
            
            fadeAnimation.fromValue = 1.0
            fadeAnimation.toValue = 0.0
        }
        
        positionAnimation.isRemovedOnCompletion = false
        fadeAnimation.isRemovedOnCompletion = false        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, fadeAnimation]
        groupAnimation.duration = 0.5
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeBoth
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.bottomLineLayer.add(groupAnimation, forKey: animationKey)
    }
}

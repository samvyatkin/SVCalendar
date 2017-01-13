//
//  SVCalendarNavigationView.swift
//  SVCalendarView
//
//  Created by Sam on 19/11/2016.
//  Copyright © 2016 Semyon Vyatkin. All rights reserved.
//

import UIKit

public enum SVCalendarNavigationDirection {
    case reduce, increase, none
}

class SVCalendarNavigationView: UIView {
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var dateTitle: UILabel!
    
    static var identifier: String {        
        return NSStringFromClass(SVCalendarNavigationView.self).replacingOccurrences(of: SVCalendarConstants.bundleIdentifier, with: "")
    }
    
    fileprivate weak var delegate: SVCalendarNavigationDelegate?
    
    var style: SVStyleProtocol? {
        didSet {
            if dateTitle != nil {
                dateTitle.textColor = self.style?.text.normalColor
                dateTitle.font = self.style?.text.font
            }
        }
    }
    var title: String? {
        didSet {
            if dateTitle != nil {
                dateTitle.text = title
            }
        }
    }
    
    // MARK: - Object LifeCycle
    static func navigation(delegate: SVCalendarNavigationDelegate?, style: SVStyleProtocol, title: String?) -> SVCalendarNavigationView {
        let nib = UINib(nibName: SVCalendarNavigationView.identifier, bundle: SVCalendarConstants.bundle!)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! SVCalendarNavigationView
        
        view.delegate = delegate
        view.style = style
        view.title = title
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configApperance()
    }
    
    deinit {
        self.clearData()
    }
    
    // MARK: - Config Appearance
    fileprivate func configApperance() {        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.style?.background.normalColor
    }
    
    // MARK: - Navigation Methods
    fileprivate func clearData() {
        self.style = nil
        self.title = nil
        self.delegate = nil
    }
    
    func updateNavigationDate(_ date: String?) {
        self.title = date
    }
    
    // MARK: - Navigation Delegates
    @IBAction func didChangeNavigationDate(_ sender: UIButton) {
        guard let date = self.delegate?.didChangeNavigationDate(direction: sender.tag == 0 ? .reduce : .increase), date != "" else {
            return
        }
        
        self.title = date
    }    
}

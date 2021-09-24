//
//  UICircularButton.swift
//  CustomRoubdedKeyboard
//
//  Created by Wajahat Hassan on 17/06/2019.
//  Copyright © 2019 digitify. All rights reserved.
//

import UIKit

public class UICircularButton: UIButton {
    
    public var buttonTitle: String? {
        didSet {
            self.setTitle(buttonTitle ?? "", for: .normal)
        }
    }
    
    public var themeColor: UIColor = .white {
        didSet {
            style(themeColor: themeColor)
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1 : 0.5
        }
    }
    
    public var buttonFont: UIFont = UIFont.systemFont(ofSize: 22)
    
    public init(title: String? = nil, themeColor: UIColor = .white) {
        self.themeColor = themeColor
        self.buttonTitle = title
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = layer.frame.height/2
        setBackgroundImage(UIImage.make(size: frame.size, color: themeColor), for: .highlighted)
        if let title = self.buttonTitle { self.setTitle(title, for: .normal) }
        style(themeColor: themeColor)
    }
    
    func commonInit() {
        setupConstraints()
        setTitleColor(.white, for: .highlighted)
        clipsToBounds = true
        backgroundColor = .clear
        layer.borderWidth = 1.5
        titleLabel?.font =  buttonFont
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func style(themeColor: UIColor) {
        setTitleColor(themeColor, for: .normal)
        layer.borderColor = themeColor.cgColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint(item: self,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: 1.0).isActive = true
    }
    
}

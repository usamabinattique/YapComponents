//
//  UIView.swift
//  YAPComponents
//
//  Created by Sarmad on 11/08/2021.
//

import UIKit

public extension UIView {
    
    @discardableResult
    func setBackgroundColor(_ color:UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func setCornerRadius(_ radious:CGFloat) -> Self {
        layer.cornerRadius = radious
        return self
    }
    
    @discardableResult
    func setBorder(width:CGFloat, color:UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    @discardableResult
    func setBorder(width:CGFloat, color:CGColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color
        return self
    }
}

// MARK: PRIVATE EXTENSIONS
internal extension UIView {
    
}

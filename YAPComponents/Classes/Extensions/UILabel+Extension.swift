//
//  UILabel+Extensions.swift
//  YapPakistanApp
//
//  Created by Sarmad on 25/08/2021.
//

import UIKit

public extension UILabel {
    
    @discardableResult func setText(_ string: String) -> Self {
        text = string
        return self
    }
    
    @discardableResult func setFont(font:UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult func setTextColor(_ color:UIColor) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult func setNumberOfLines(_ lines:Int) -> Self {
        numberOfLines = lines
        return self
    }
    
    @discardableResult func setTextAlligned(_ alignment:NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult func setLineBreakMode(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }
    
    @discardableResult func setAdjustsFontSizeToFitWidth(_ value:Bool) -> Self {
        adjustsFontSizeToFitWidth = value
        return self
    }
}

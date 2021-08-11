//
//  UIButton.swift
//  YAPComponents
//
//  Created by Sarmad on 11/08/2021.
//

import UIKit

public extension UIButton {
    
    @discardableResult
    func setTitle(_ title:String, for state:UIControl.State) -> Self {
        setTitle(title, for: state)
        return self
    }
    
}

// MARK: PRIVATE EXTENSIONS
internal extension UIButton {
    
}


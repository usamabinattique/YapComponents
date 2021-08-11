//
//  UITextView+Extension.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 02/02/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.tintColor = UIColor.primaryDark
        self.inputAccessoryView = toolBar
    }
}

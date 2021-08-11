//
//  StaticTextFieldFactory.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 03/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class StaticTextFieldFactory {
    
    public class func createField(title: String = String(),
                                  text: String = String(),
                                  isEditable: Bool = false) -> StaticAppTextField {
        let field = StaticAppTextField()
        field.titleLabel.text = title
        field.textLabel.text = text
        field.isEditable = isEditable
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}

//
//  AppRoundedButtonFactory.swift
//  YAPKit
//
//  Created by Hussaan S on 26/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import UIKit

public class AppRoundedButtonFactory {
    
    public class func createAppRoundedButton(title: String = String(), backgroundColor: UIColor = .blue , font:  UIFont = UIFont.systemFont(ofSize: 12) , textColor: UIColor =  .white, isEnable: Bool = true, icon: UIImage? = nil) -> AppRoundedButton {
        let button = AppRoundedButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = font
        button.translatesAutoresizingMaskIntoConstraints = false
        icon.map { button.icon = $0; button.iconPosition = .right }
        button.isEnabled = isEnable
        return button
    }
}

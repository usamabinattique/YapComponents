//
//  AppRoundedButtonFactory.swift
//  YAPKit
//
//  Created by Hussaan S on 26/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class AppRoundedButtonFactory {
    
    public class func createAppRoundedButton(title: String = String(), backgroundColor: UIColor = .blue /*UIColor.appColor(ofType: .primary)*/, textColor: UIColor =  .white, isEnable: Bool = true, icon: UIImage? = nil) -> AppRoundedButton {
        let button = AppRoundedButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        icon.map { button.icon = $0; button.iconPosition = .right }
        button.isEnabled = isEnable
        return button
    }
}

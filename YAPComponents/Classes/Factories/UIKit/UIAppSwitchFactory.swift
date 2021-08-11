//
//  UIAppSwitchFactory.swift
//  YAPKit
//
//  Created by Zain on 13/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public class UIAppSwitchFactory {
    
    public static func createUIAppSwitch(isOn: Bool = false, onTintColor: UIColor = .primary, offTintColor: UIColor = .greyLight, onImage: UIImage? = UIImage.sharedImage(named: "icon_check_primary_dark")?.asTemplate, offImage: UIImage? = nil) -> UIAppSwitch {
        
        let appSwitch = UIAppSwitch()
        appSwitch.onTintColor = onTintColor
        appSwitch.offTintColor = offTintColor
        appSwitch.onImage = onImage
        appSwitch.offImage = offImage
        appSwitch.isOn = isOn
        appSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return appSwitch
    }
}

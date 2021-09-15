//
//  UIAppSwitchFactory.swift
//  YAPKit
//
//  Created by Zain on 13/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public extension UIFactory {
    
    public static func makeAppSwitch(isOn: Bool = false, onTintColor: UIColor = .blue /*.primary*/, offTintColor: UIColor = .lightGray /*.greyLight*/, onImage: UIImage? = nil /*= UIImage.sharedImage(named: "icon_check_primary_dark")?.asTemplate*/, offImage: UIImage? = nil) -> AppSwitch {
        
        let appSwitch = AppSwitch()
        appSwitch.onTintColor = onTintColor
        appSwitch.offTintColor = offTintColor
        appSwitch.onImage = onImage
        appSwitch.offImage = offImage
        appSwitch.isOn = isOn
        appSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return appSwitch
    }
}

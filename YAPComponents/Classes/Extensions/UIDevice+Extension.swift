//
//  UIDevice+Extension.swift
//  YAPKit
//
//  Created by Uzair on 07/07/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

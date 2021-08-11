//
//  UIWindow+Extension.swift
//  YAPKit
//
//  Created by Janbaz Ali on 03/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public extension UIWindow {
    
    static var keyWindow: UIWindow? {
        UIApplication.shared.keyWindow
    }
}

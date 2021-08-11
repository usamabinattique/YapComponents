//
//  UIApplication+Extensions.swift
//  YAPComponents
//
//  Created by Sarmad on 11/08/2021.
//

import UIKit

public extension UIApplication {
    
    static func topViewController() -> UIViewController? {
        var top = UIApplication.shared.keyWindow?.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
    
}

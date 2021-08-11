//
//  UINavigationControllerFactory.swift
//  YAPKit
//
//  Created by Hussaan S on 30/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import UIKit
public class UINavigationControllerFactory {
    
    public class func createTransparentNavigationBarNavigationController(rootViewController: UIViewController, barStyle: UIBarStyle? = .default ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = .primary
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createOpaqueNavigationBarNavigationController(rootViewController: UIViewController, themed: Bool = false, barStyle: UIBarStyle? = .default ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = themed ? .white : .primary
        nav.navigationBar.barTintColor = themed ? .primary : .white
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: themed ? UIColor.white : UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createColoredNavigationBarNavigationController(rootViewController: UIViewController, barBackgroundColor: UIColor, barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = .primary
        nav.navigationBar.barTintColor = barBackgroundColor
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createColoredNavigationBarNavigationController(rootViewController: UIViewController, tintColor: UIColor, barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = tintColor
        nav.navigationBar.barTintColor = .primary
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createTransparentNavigationBarNavigationController(barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.tintColor = .primary
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
}

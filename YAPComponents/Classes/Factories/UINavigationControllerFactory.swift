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
    
    public class func createAppThemedNavigationController(root viewController: UIViewController? = nil, themeColor: UIColor, font: UIFont) -> UINavigationController {
        
        var navigation: UINavigationController!
        if let root = viewController {
            navigation = UINavigationController(rootViewController: root)
        } else {
            navigation = UINavigationController()
        }
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor:themeColor]
        navigation.modalPresentationStyle = .fullScreen
        
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.isOpaque = true
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.setNavigationBarHidden(false, animated: true)
        
        if #available(iOS 15, *) {
            let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: themeColor]
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = textAttributes
            appearance.backgroundColor = UIColor.white // UIColor(red: 0.0/255.0, green: 125/255.0, blue: 0.0/255.0, alpha: 1.0)
            appearance.shadowColor = .clear  //removing navigationbar 1 px bottom border.
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            navigation.navigationBar.barTintColor = .white
        }
        
        
        return navigation
    }
    
    public class func createTransparentNavigationBarNavigationController(rootViewController: UIViewController, barStyle: UIBarStyle? = .default ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = .blue ///.primary
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        ///nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createOpaqueNavigationBarNavigationController(rootViewController: UIViewController, themed: Bool = false, barStyle: UIBarStyle? = .default, themeColor: UIColor = UIColor.hexStringToUIColor(hex: "5E35B1"), font: UIFont = .systemFont(ofSize: 16.0)) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = themed ? .white : .blue ///.primary
        nav.navigationBar.barTintColor = themed ? /*.primary*/ .blue : .white
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        
        if #available(iOS 15, *) {
            let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: themeColor]
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = textAttributes
            appearance.backgroundColor = UIColor.white // UIColor(red: 0.0/255.0, green: 125/255.0, blue: 0.0/255.0, alpha: 1.0)
            appearance.shadowColor = .clear  //removing navigationbar 1 px bottom border.
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            nav.navigationBar.barTintColor = .white
        }
        
        //nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: themed ? UIColor.white : UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createColoredNavigationBarNavigationController(rootViewController: UIViewController, barBackgroundColor: UIColor, barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = .blue ///.primary
        nav.navigationBar.barTintColor = barBackgroundColor
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isTranslucent = false
        ///nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createColoredNavigationBarNavigationController(rootViewController: UIViewController, tintColor: UIColor, barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = tintColor
        nav.navigationBar.barTintColor = .blue ///.primary
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isOpaque = true
        nav.navigationBar.isTranslucent = false
        //nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
    
    public class func createTransparentNavigationBarNavigationController(barStyle: UIBarStyle? = .default) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.tintColor = .blue ///.primary
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.isHidden = false
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.regular, NSAttributedString.Key.foregroundColor: UIColor.primaryDark]
        nav.navigationBar.barStyle = barStyle ?? .default
        return nav
    }
}

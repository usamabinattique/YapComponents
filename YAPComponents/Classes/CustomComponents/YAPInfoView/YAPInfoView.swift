//
//  YAPInfoView.swift
//  YAPKit
//
//  Created by Zain on 07/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class YAPInfoView {
    
    // MARK: Properties
    
    let viewController: YAPInfoViewController!
    
    // MARK: Initialization
    
    public init(info: String, origin: CGPoint) {
        viewController = YAPInfoViewController(info: info, origin: origin)
    }
    
}

// MARK: Public methods

public extension YAPInfoView {
    
    func show() {
        
        UIApplication.shared.windows.filter{ $0.tag == 0xdead }.forEach {
            $0.rootViewController?.dismiss(animated: false, completion: nil)
            $0.removeFromSuperview()
        }
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        
        alertWindow.rootViewController = YAPInfoViewRootViewController(nibName: nil, bundle: nil)
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert + 1
        alertWindow.isHidden = false
        alertWindow.tag = 0xdead
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        
        alertWindow.rootViewController?.present(nav, animated: false, completion: nil)
        
        viewController.window = alertWindow
    }
}

// MARK: Root View controller

private class YAPInfoViewRootViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIApplication.shared.statusBarStyle
        }
    }
}

// MARK: Developer convenience methods

public extension YAPInfoView {
    static func show(info: String, fromView view: UIView) {
        var origin = view.superview?.convert(view.frame.origin, to: nil) ?? .zero
        
        origin.x = origin.x + view.bounds.width
        origin.y -= 15
        
        YAPInfoView(info: info, origin: origin).show()
    }
}

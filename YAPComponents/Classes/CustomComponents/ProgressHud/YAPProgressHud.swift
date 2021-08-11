//
//  YAPProgressHud.swift
//  YAPKit
//
//  Created by Zain on 27/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum YAPProgressHudIndicatorType {
    case snake
    case standered
    case spinningCircle
}

public class YAPProgressHud {
    
    // MARK: Properties
    
    private static var progressWindow: UIWindow?
    
    // MARK: Public function
    
    public static func showProgressHud(toView view: UIView? = nil, withType type: YAPProgressHudIndicatorType = .spinningCircle) {
        if let `view` = view {
            showHud(toView: view, withType: type)
        } else {
            showHudToWindow(withType: type)
        }
    }
    
    public static func hideProgressHud(fromView view: UIView? = nil) {
        if let `view` = view {
            hideHud(fromView: view)
        } else {
            hideHudFromWindow()
        }
    }
    
    // MARK: Private functions
    
    private static func showHud(toView view: UIView, withType type: YAPProgressHudIndicatorType) {
        hideHud(fromView: view)
        let hud = YAPProgressHudView(frame: view.bounds, indicatorType: type)
        hud.isUserInteractionEnabled = true
        view.addSubview(hud)
    }
    
    private static func showHudToWindow(withType type: YAPProgressHudIndicatorType) {
        
        guard progressWindow == nil else { return }
        
        progressWindow = UIWindow(frame: UIScreen.main.bounds)
        progressWindow?.backgroundColor = .clear
        progressWindow?.windowLevel = .alert + 1
        showHud(toView: progressWindow!, withType: type)
        progressWindow?.makeKeyAndVisible()
    }
    
    private static func hideHud(fromView view: UIView) {
        view.subviews.filter { $0 is YAPProgressHudView }.forEach { ($0 as? YAPProgressHudView)?.removeProgressHud() }
    }
    
    private static func hideHudFromWindow() {
        progressWindow?.resignKey()
        progressWindow?.removeFromSuperview()
        progressWindow = nil
    }   
}

private class YAPProgressHudView: UIView {
    
    // MARK: Initialization
    
    var indicatorType: YAPProgressHudIndicatorType = .spinningCircle
    
    init(frame: CGRect, indicatorType: YAPProgressHudIndicatorType) {
        self.indicatorType = indicatorType
        super.init(frame: frame)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = false
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.alpha = 0
        addIndicatorView()
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = 1
        }
    }
    
    fileprivate func removeProgressHud() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (_) in
            self?.removeFromSuperview()
        }
    }
}

private extension YAPProgressHudView {
    func addIndicatorView() {
        let height: CGFloat = 90
        let indicator: UIView!
        switch indicatorType {
        case .standered:
            indicator = UIActivityIndicatorView(style: .whiteLarge)
            indicator.center = center
            (indicator as! UIActivityIndicatorView).startAnimating()
        case .snake:
            indicator = SnakeIndicatorView(frame: CGRect(x: bounds.size.width/2 - height/2, y: bounds.height/2 - height/2, width: height, height: height))
        case .spinningCircle:
            indicator = YAPActivityIndicatorView(frame: CGRect(x: bounds.size.width/2, y: bounds.height/2, width: height, height: height))
        }
        addSubview(indicator)
    }
}

// MAKR: Reactive

public extension Reactive where Base: YAPProgressHud {
    static var showActivity: Binder<Bool> {
        return Binder(UIApplication.shared) { _, showActivity -> Void in
            showActivity ? YAPProgressHud.showProgressHud() : YAPProgressHud.hideProgressHud()
        }
    }
}

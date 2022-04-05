//
//  UIView+Extensions.swift
//  YAPKit
//
//  Created by Zain on 20/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift
//import RxCocoa

// MARK: View animations

public enum ViewAnimationType {
    case bounce
}

public extension UIView {
    func bounce() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.08
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
        layer.add(animation, forKey: nil)
    }

    fileprivate func animate(withType type: ViewAnimationType) {
        switch type {
        case .bounce:
            bounce()
        }
    }
}

public extension UIView {
    var centerInWindow: CGPoint {
        superview?.convert(center, to: nil) ?? .zero
    }
}

public extension UIView{
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

public extension UIView {
    var globalFrameNew: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

// MARK: Activity Indicator

public extension UIView {

    func showProgressActivity() {
        YAPProgressHud.showProgressHud(toView: self)
    }

    func hideProgressActivity() {
        YAPProgressHud.hideProgressHud(fromView: self)
    }
}

// MARK: Animate hidden
public extension UIView {
    func animateIsHidden(_ hidden: Bool) {
        guard hidden != isHidden else { return }
        let newAlpha = alpha
        if !hidden {
            alpha = 0
            isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.alpha = hidden ? 0 : newAlpha
        }) { [unowned self] (completed) in
            if completed {
                self.isHidden = hidden
                self.alpha = newAlpha
            }
        }
    }
}

// MARK: - UIView + Gradient
enum LayerName: String {
    case gradient = "gradient"
}

public extension UIView {
    func setGradientBackground(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = LayerName.gradient.rawValue
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func removeGradientBackground() {
        self.layer.sublayers?.filter { $0.name == LayerName.gradient.rawValue }.first?.removeFromSuperlayer()
    }
}

// MARK: Reusable view
public protocol ReusableView: class {}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: Rounded view

public extension UIView {
    func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
        layer.cornerRadius = bounds.height/2
        layer.borderWidth = width ?? 0
        layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
        layer.masksToBounds = false
        clipsToBounds = true
    }
    
    func applyShadow() {
        self.layer.shadowRadius = self.frame.width / 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.gray.cgColor //UIColor.grey.cgColor
        self.layer.masksToBounds = false
        self.backgroundColor = .white
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    func applyDarkShadow() {
        layoutIfNeeded()
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height/2)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = shadowPath.cgPath
    }
}

// MARK: Alert

public extension UIView {
    func showAlert(type: YAPAlert.AlertType, text: String, from direction: YAPAlert.AlertDirection = .top, autoHide: Bool = true, autoHideDuration: TimeInterval = 5) {
        YAPAlert().show(inView: self, type: type, text: text, from: direction, autoHides: autoHide, autoHideDuration: autoHideDuration)
    }
    
    func hideAlert() {
        _ = subviews.filter { $0 is YAPAlert }.map { ($0 as? YAPAlert)?.hide() }
    }
}

// MARK: View + rounded corners

public extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        clipsToBounds = true
    }
}

// MARK: View + Shimmer layer

public extension UIView {
    var isShimmerOn: Bool {
        get { return shimmerable }
        set { shimmerable = newValue
            newValue ? startShimmeringEffect() : stopShimmeringEffect()
        }
    }

    private var shimmerable: Bool {
        get { return objc_getAssociatedObject(self, "pkey") as? Bool ?? false }
        set { objc_setAssociatedObject(self, "pkey", newValue, objc_AssociationPolicy(rawValue: 1)!) }
    }
    
    private  func removeShimmerLayer(){
        layer.mask = nil
    }
    
   
    func startShimmeringEffect() {
//        let light = UIColor(red: 218, green: 224, blue: 240, alpha: 1.0)
//        let alpha = UIColor(red: 201, green: 200, blue: 216, alpha: 1.0)
        
        let light = UIColor(rgb: 0xE8ECF6).cgColor //UIColor.hexStringToUIColor(hex: "#E8ECF6") //UIColor.lightGray.cgColor
        let alpha = UIColor(rgb: 0xE8ECF6).cgColor //UIColor.gray.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width:self.bounds.size.width, height: self.bounds.size.height)
        gradient.colors = [light, alpha, alpha, light]
        gradient.startPoint = CGPoint(x: 0.0, y: 1)
        gradient.endPoint = CGPoint(x: 1.0,y: 1)
        gradient.locations = [0.0, 0.3, 0.5, 1]
        
        gradient.cornerRadius = 5
        gradient.masksToBounds = true
        
        self.layer.addSublayer(gradient)
        clipsToBounds = true
        
        let animation = CABasicAnimation(keyPath: "locations")
        
        animation.fromValue = [-1, -0.3, -0.5, 0]
        animation.toValue = [1.0, 1.3, 1.5, 2]
        animation.duration = 1.7
        animation.repeatCount = .infinity
        
        gradient.add(animation, forKey: "shimmer")
    
        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        
    }
    func stopShimmeringEffect() {
        if let gradientLayer =  self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        {
            gradientLayer.removeFromSuperlayer()
        }
        layer.mask = nil
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        if let gradientLayer =  self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.isKind(of: CAGradientLayer.self)
        })
        {
            gradientLayer.frame = CGRect(x:0 , y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        }
    }
}

public extension UIView {
    func layoutAllSuperViews() {
        if let view = superview {
            view.layoutAllSuperViews()
        }
        layoutSubviews()
    }
    
    func layoutAllSubviews() {
        subviews.forEach{ $0.layoutAllSubviews() }
        layoutSubviews()
    }
}

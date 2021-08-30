//
//  UIViewLayout+Extensions.swift
//  YAPComponents
//
//  Created by Sarmad on 30/08/2021.
//

import UIKit

//MARK: - Layout Constraints
public extension UIView {
    
    @discardableResult func height (
        _ constant: CGFloat,
        priority:Float = 1000
    ) -> UIView {
        let height = heightAnchor.constraint(equalToConstant: constant)
        height.priority = UILayoutPriority(priority)
        height.isActive = true
        return self
    }
    @discardableResult func height(
        _ equalTo: NSLayoutDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let height = heightAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
        height.priority = UILayoutPriority(priority)
        height.isActive = true
        return self
    }
    
    @discardableResult func width(
        _ constant: CGFloat,
        priority:Float = 1000
    ) -> UIView {
        let width = widthAnchor.constraint(equalToConstant: constant)
        width.priority = UILayoutPriority(priority)
        width.isActive = true
        return self
    }
    @discardableResult func width(
        _ equalTo: NSLayoutDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let width = widthAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
        width.priority = UILayoutPriority(priority)
        width.isActive = true
        return self
    }
    
    @discardableResult func top(
        _ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let top = topAnchor.constraint(equalTo: equalTo, constant: constant)
        top.priority = UILayoutPriority(priority)
        top.isActive = true
        return self
    }
    
    @discardableResult func bottom(
        _ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        bottomAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func left(
        _ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let left = leftAnchor.constraint(equalTo: equalTo, constant: constant)
        left.priority = UILayoutPriority(priority)
        left.isActive = true
        return self
    }
    
    @discardableResult func right(
        _ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let right = rightAnchor.constraint(equalTo: equalTo, constant: constant)
        right.priority = UILayoutPriority(priority)
        right.isActive = true
        return self
    }
    
    @discardableResult func centerX(
        _ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let centerX = centerXAnchor.constraint(equalTo: equalTo, constant: constant)
        centerX.priority = UILayoutPriority(priority)
        centerX.isActive = true
        return self
    }
    
    @discardableResult func centerY (
        _ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0,
        priority:Float = 1000
    ) -> UIView {
        let centerY = centerYAnchor.constraint(equalTo: equalTo, constant: constant)
        centerY.priority = UILayoutPriority(priority)
        centerY.isActive = true
        return self
    }
}

public extension UIView {
    
    @discardableResult func setContentHugging(
        _ priority:Float,
        axix:NSLayoutConstraint.Axis
    ) -> Self {
        setContentHuggingPriority(UILayoutPriority(priority), for: axix)
        return self
    }
    
    @discardableResult func setContentCompression(
        _ resistancePriority:Float,
        axix:NSLayoutConstraint.Axis
    ) -> Self {
        setContentCompressionResistancePriority(UILayoutPriority(resistancePriority), for: axix)
        return self
    }
    
    @discardableResult func setTranslatesAutoresizingMaskIntoConstraints(
        _ value:Bool
    ) -> Self {
        translatesAutoresizingMaskIntoConstraints = value
        return self
    }
    
}


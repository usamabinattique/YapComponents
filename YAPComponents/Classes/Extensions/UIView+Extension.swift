//
//  UIView+Extensions.swift
//  iOSApp
//
//  Created by Abbas on 06/06/2021.
//

import UIKit

public extension UIView {
    
    @discardableResult func setAlpha(_ value:CGFloat) -> Self {
        alpha = value
        return self
    }
    
    @discardableResult
    func setBackgroundColor(_ color:UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func setCornerRadius(_ radious:CGFloat) -> Self {
        layer.cornerRadius = radious
        return self
    }
    
    @discardableResult
    func setBorder(width:CGFloat, color:UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    @discardableResult
    func setBorder(width:CGFloat, color:CGColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color
        return self
    }
    
    @discardableResult
    func setUserInteraction(_ enabled:Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }

    @discardableResult
    func setHidden(_ bool:Bool) -> Self {
        self.isHidden = bool
        return self
    }
    
    @discardableResult
    func setTintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func setBorder(_ color:UIColor, width:CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
        
    @discardableResult
    func setContentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    @discardableResult
    func shaddow(
        radius:CGFloat = 1,
        color:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        opacity:Float = 0.2,
        offsetY:CGFloat ) -> Self {
        shaddow(radius: radius, color: color, opacity: opacity, offset: CGSize(width: 0, height: offsetY))
        return self
    }
    
    @discardableResult
    func shaddow(radius:CGFloat = 1,
                    color:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                    opacity:Float = 0.15,
                    offset:CGSize = CGSize(width: 0, height: 0)) -> Self {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        return self
    }
    
    @discardableResult func addSub(view:UIView) -> Self {
        addSubview(view)
        return self
    }
    
    @discardableResult func addToSuper(view:UIView) -> Self {
        view.addSubview(self)
        return self
    }
}

//MARK: - Layout Constraints
extension UIView {
    
    @discardableResult
    func height (_ constant: CGFloat, priority:Float = 1000) -> UIView {
        let height = heightAnchor.constraint(equalToConstant: constant)
        height.priority = UILayoutPriority(priority)
        height.isActive = true
        return self
    }
    @discardableResult
    func height(_ equalTo: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let height = heightAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
        height.priority = UILayoutPriority(priority)
        height.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat, priority:Float = 1000) -> UIView{
        let width = widthAnchor.constraint(equalToConstant: constant)
        width.priority = UILayoutPriority(priority)
        width.isActive = true
        return self
    }
    @discardableResult
    func width(_ equalTo: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let width = widthAnchor.constraint(equalTo: equalTo, multiplier: multiplier, constant: constant)
        width.priority = UILayoutPriority(priority)
        width.isActive = true
        return self
    }
    
    @discardableResult
    func top(_ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let top = topAnchor.constraint(equalTo: equalTo, constant: constant)
        top.priority = UILayoutPriority(priority)
        top.isActive = true
        return self
    }
    @discardableResult
    func bottom(_ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        bottomAnchor.constraint(equalTo: equalTo, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func left(_ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let left = leftAnchor.constraint(equalTo: equalTo, constant: constant)
        left.priority = UILayoutPriority(priority)
        left.isActive = true
        return self
    }
    
    @discardableResult
    func right(_ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let right = rightAnchor.constraint(equalTo: equalTo, constant: constant)
        right.priority = UILayoutPriority(priority)
        right.isActive = true
        return self
    }
    
    @discardableResult
    func centerX(_ equalTo:  NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let centerX = centerXAnchor.constraint(equalTo: equalTo, constant: constant)
        centerX.priority = UILayoutPriority(priority)
        centerX.isActive = true
        return self
    }
    
    @discardableResult
    func centerY(_ equalTo:  NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0, priority:Float = 1000) -> UIView {
        let centerY = centerYAnchor.constraint(equalTo: equalTo, constant: constant)
        centerY.priority = UILayoutPriority(priority)
        centerY.isActive = true
        return self
    }
}
 
extension UIView {
    
    @discardableResult
    func setContentHugging(_ priority:Float,
                           axix:NSLayoutConstraint.Axis ) -> Self {
        setContentHuggingPriority(UILayoutPriority(priority), for: axix)
        return self
    }
    
    @discardableResult
    func setContentCompression( _ resistancePriority:Float,
                                axix:NSLayoutConstraint.Axis ) -> Self {
        setContentCompressionResistancePriority(UILayoutPriority(resistancePriority), for: axix)
        return self
    }
    
    @discardableResult func setTranslatesAutoresizingMaskIntoConstraints(_ value:Bool) -> Self {
        translatesAutoresizingMaskIntoConstraints = value
        return self
    }
    
}














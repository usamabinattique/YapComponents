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
    
    @discardableResult func setCornerRadius(_ radious:CGFloat) -> Self {
        layer.cornerRadius = radious
        return self
    }
    
    @discardableResult func setBorder(width:CGFloat, color:UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    @discardableResult func setBorder(width:CGFloat, color:CGColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color
        return self
    }
    
    @discardableResult func setUserInteraction(_ enabled:Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }

    @discardableResult func setHidden(_ bool:Bool) -> Self {
        self.isHidden = bool
        return self
    }
    
    @discardableResult func setTintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult func setBorder(_ color:UIColor, width:CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
        
    @discardableResult func setContentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    @discardableResult func shaddow(
        radius:CGFloat = 1,
        color:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        opacity:Float = 0.2,
        offsetY:CGFloat ) -> Self {
        shaddow(radius: radius, color: color, opacity: opacity, offset: CGSize(width: 0, height: offsetY))
        return self
    }
    
    @discardableResult func shaddow(radius:CGFloat = 1,
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












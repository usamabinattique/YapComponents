//
//  DefaultAppButton.swift
//  YAPComponents
//
//  Created by Sarmad on 10/08/2021.
//

import UIKit

public class AppButton:UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    func setTitle(_ title:String) -> Self {
        setTitle(title, for: .normal)
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
}

//MARK: Private Methods
fileprivate extension AppButton {
    func layoutSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        //button.titleLabel?.font = UIFont.appFont(forTextStyle: .large,weight: .medium)
    }
}

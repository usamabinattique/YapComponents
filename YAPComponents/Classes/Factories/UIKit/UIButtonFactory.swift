//
//  UIButtonFactory.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 31/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
public class UIButtonFactory {
    
    public class func createButton(title: String = String(), backgroundColor: UIColor = UIColor.appColor(ofType: .primaryDark), textColor: UIColor =  UIColor.appColor(ofType: .primary)) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

public class UIVerticalButtonFactory {
    public class func createVerticalButton(title: String? = nil, image: UIImage? = nil) -> UIVerticalButton {
        let button = UIVerticalButton()
        button.title = title
        button.image = image
        return button
    }
}

//
//  UIButtonFactory.swift
//  YAPComponents
//
//  Created by Yasir on 10/02/2022.
//

import Foundation
public class UIButtonFactory {
    
    public class func createButton(title: String = String(), backgroundColor: UIColor = .gray, textColor: UIColor =  UIColor.yellow) -> UIButton {
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

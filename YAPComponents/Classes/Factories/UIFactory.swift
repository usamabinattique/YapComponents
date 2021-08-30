//
//  File.swift
//  YapPakistanApp
//
//  Created by Sarmad on 24/08/2021.
//

import UIKit

public class UIFactory {}

public extension UIFactory {
    class func makeView(with color:UIColor = .clear,
                        cornerRadious:CGFloat = 0,
                        borderColor:UIColor = .clear,
                        borderWidth:CGFloat = 0 ) -> View {
        return View()
            .setBackgroundColor(color)
            .setCornerRadius(cornerRadious)
            .setBorder(borderColor, width: borderWidth)
    }
}

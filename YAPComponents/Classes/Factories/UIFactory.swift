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

public extension UIFactory {
    class func makeLabel (
        with color: UIColor? = nil,
        textStyle style: AppTextStyle = .title1,
        fontWeight weight: UIFont.Weight = .regular,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        text: String? = nil,
        alpha: CGFloat = 1.0,
        adjustFontSize: Bool = false,
        insects:UIEdgeInsets = .zero
    ) -> Label {
        
        return Label()
            .setFont(font: UIFont.appFont(for: style, weight: weight, scale: 1.dynamic))
            .setTextAlligned(alignment)
            .setNumberOfLines(numberOfLines)
            .setLineBreakMode(lineBreakMode)
            .setText(text ?? "")
            .setAlpha(alpha)
            .setTranslatesAutoresizingMaskIntoConstraints(false)
            .setAdjustsFontSizeToFitWidth(adjustFontSize)
            .setInsets(insects)
            .setTextColor(color ?? .darkText)
    }
}

extension UIFactory {
    class func makeImageView(name:String,
                             tintColor:UIColor = .black,
                             contentMode:UIView.ContentMode = .scaleAspectFit,
                             rendringMode:UIImage.RenderingMode = .alwaysOriginal
                             ) -> ImageView {
        return ImageView()
            .setTintColor(tintColor)
            .setContentMode(contentMode)
            .setImage(name, rendringMode: rendringMode)
    }
    
    class func makeImageView(image:UIImage,
                             tintColor:UIColor = .black,
                             contentMode:UIView.ContentMode = .scaleAspectFit,
                             rendringMode:UIImage.RenderingMode = .alwaysOriginal
                             ) -> ImageView {
        return ImageView()
            .setTintColor(tintColor)
            .setContentMode(contentMode)
            .setImage(image, rendringMode: rendringMode)
    }
}

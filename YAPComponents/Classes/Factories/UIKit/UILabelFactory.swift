//
//  UILabelFactory.swift
//  YAPKit
//
//  Created by Hussaan S on 26/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit


public class UILabelFactory {

    public class func createUILabel<T: UILabel>(with colorType: AppColorType = .primary, textStyle: AppTextStyle = .title1,fontWeight: AppFontWeight = .regular, alignment: NSTextAlignment = .left, numberOfLines: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail, text: String? = nil, alpha: CGFloat = 1.0, adjustFontSize: Bool = false) -> T {
        let label = T()
        label.font = UIFont.appFont(forTextStyle: textStyle, weight: fontWeight)
        label.textColor = UIColor.appColor(ofType: colorType)
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.text = text
        label.alpha = alpha
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustFontSize
        return label
    }
}

public extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}

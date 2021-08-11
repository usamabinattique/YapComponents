//
//  KYCAmountTextField.swift
//  YAPKit
//
//  Created by Janbaz Ali on 14/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
//public class KYCAmountTextField: AmountTextField {
//
//    public convenience init (alignment: NSTextAlignment, font: UIFont) {
//         self.init()
//         textAlignment = alignment
//         formattedLabel.textAlignment = alignment
//         appFont = font
//     }
//
//    override func editted() {
//        textColor = .clear
//        var `text` = self.text ?? ""
//        text = text.replacingOccurrences(of: ",", with: "")
//
//        if text.contains(".") {
//            let fractions = (text.count - 1) - (text as NSString).range(of: ".").location
//            if fractions > numberOfFractionDigits {
//                text.removeLast(fractions - numberOfFractionDigits)
//            }
//
//        }
//
//        let doubleValue = Double(text) ?? 0
//        let formattedText = numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
//        let attributed = NSMutableAttributedString(string: formattedText)
//        attributed.addAttributes([.foregroundColor: _textColor ?? .black], range: NSRange(location: 0, length: formattedText.count))
//        var textToAppend = formattedText
//        if text.contains(".") {
//            let fractions = (text.count - 1) - (text as NSString).range(of: ".").location
//            textToAppend.removeLast(numberOfFractionDigits - fractions)
//
//        } else {
//            textToAppend.removeLast(numberOfFractionDigits + 1)
//            if text.isEmpty { textToAppend.removeLast(1) }
//        }
//
//        self.text = textToAppend
//
//        guard let grayRange = grayRange(for: text, formattedText: formattedText) else {
//            self.formattedLabel.attributedText = attributed
//            return
//        }
//
//        attributed.addAttributes([.foregroundColor: UIColor.lightGray], range: grayRange)
//        self.formattedLabel.attributedText = attributed
//    }
//
//}


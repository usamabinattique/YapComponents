//
//  UIButton+Extension.swift
//  YAPComponents
//
//  Created by Uzair on 18/10/2021.
//

import UIKit

public extension UIButton {
    
    func underline() {
          guard let text = self.titleLabel?.text else { return }
          let attributedString = NSMutableAttributedString(string: text)
          //NSAttributedStringKey.foregroundColor : UIColor.blue
          attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
          attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
          self.setAttributedTitle(attributedString, for: .normal)
      }
}
